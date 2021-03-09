/* address ranges */
/* [min, max) of the matching range. */
type spmp_addr_range = option((xlenbits, xlenbits))

function spmpAddrRange(cfg: Spmpcfg_ent, spmpaddr: xlenbits, prev_spmpaddr: xlenbits) -> spmp_addr_range = {
  match spmpAddrMatchType_of_bits(cfg.A()) {
    OFF   => None(),
    TOR   => { Some ((prev_spmpaddr << 2, spmpaddr << 2)) },
    NA4   => { let lo = spmpaddr << 2;
               Some((lo, lo + 4))
             },
    NAPOT => { let mask = spmpaddr ^ (spmpaddr + 1);  // generate 1s in signifying bits
               let lo   = spmpaddr & (~ (mask));
               let len  = mask + 1;
               Some((lo << 2, (lo + len) << 2))
             }
  }
}

/* permission checks */
val checkRWX: (Spmpcfg_ent, AccessType(ext_access_type), Privilege) -> bool
function checkRWX(ent, acc, priv) = {
  match acc {
    Read(_)      => ent.R() == 0b1,
    Write(_)     => ent.W() == 0b1,
    ReadWrite(_) => ent.R() == 0b1 & ent.W() == 0b1,
    Execute()    => ent.X() == 0b1 & (priv == User | (priv == Supervisor & ent.S() == 0b1))
  }
}

val spmpCheckRWX: (Spmpcfg_ent, AccessType(ext_access_type), Privilege) -> bool effect {rreg}
function spmpCheckRWX(ent, acc, priv) = {
  let do_sum : bool = mstatus.SUM() == 0b1;

  match (ent.S(), ent.R(), ent.W(), ent.X()) {
    (0b0, 0b0, 0b0, 0b0) => false,
    (0b0, 0b0, 0b0, 0b1) => priv == User & acc == Execute(),
    (0b0, 0b0, 0b1, 0b0) => (priv == User & acc == Read()) | (priv == Supervisor & acc != Execute()),
    (0b0, 0b0, 0b1, 0b1) => acc != Execute(),
    (0b0, 0b1, 0b0, 0b0) => (priv == User | (priv == Supervisor & do_sum)) & checkRWX(ent, acc, priv),
    (0b0, 0b1, 0b0, 0b1) => (priv == User | (priv == Supervisor & do_sum)) & checkRWX(ent, acc, priv),
    (0b0, 0b1, 0b1, 0b0) => (priv == User | (priv == Supervisor & do_sum)) & checkRWX(ent, acc, priv),
    (0b0, 0b1, 0b1, 0b1) => (priv == User | (priv == Supervisor & do_sum)) & checkRWX(ent, acc, priv),
    (0b1, 0b0, 0b0, 0b0) => true,
    (0b1, 0b0, 0b0, 0b1) => priv == Supervisor & checkRWX(ent, acc, priv),
    (0b1, 0b0, 0b1, 0b0) => acc == Execute(),
    (0b1, 0b0, 0b1, 0b1) => (priv == User & acc == Execute()) | (priv == Supervisor & (acc == Execute() | acc == Read())),
    (0b1, 0b1, 0b0, 0b0) => priv == Supervisor & checkRWX(ent, acc, priv),
    (0b1, 0b1, 0b0, 0b1) => priv == Supervisor & checkRWX(ent, acc, priv),
    (0b1, 0b1, 0b1, 0b0) => priv == Supervisor & checkRWX(ent, acc, priv),
    (0b1, 0b1, 0b1, 0b1) => acc == Read()
  }
}

// this needs to be called with the effective current privilege.
val spmpCheckPerms: (Spmpcfg_ent, AccessType(ext_access_type), Privilege) -> bool effect {rreg}
function spmpCheckPerms(ent, acc, priv) = {
  match priv {
    Machine => true,
    _       => spmpCheckRWX(ent, acc, priv)
  }
}

/* matching logic */

enum spmpAddrMatch = {SPMP_NoMatch, SPMP_PartialMatch, SPMP_Match}

function spmpMatchAddr(addr: xlenbits, width: xlenbits, rng: spmp_addr_range) -> spmpAddrMatch = {
  match rng {
    None()         => SPMP_NoMatch,
    Some((lo, hi)) => if   hi <_u lo   /* to handle mis-configuration */
                      then SPMP_NoMatch
                      else {
                        if      (addr + width <_u lo) | (hi <_u addr)
                        then    SPMP_NoMatch
                        else if (lo <=_u addr) & (addr + width <=_u hi)
                        then    SPMP_Match
                        else    SPMP_PartialMatch
                      }
  }
}

enum spmpMatch = {SPMP_Success, SPMP_Continue, SPMP_Fail}

function spmpMatchEntry(addr: xlenbits, width: xlenbits, acc: AccessType(ext_access_type), priv: Privilege,
                       ent: Spmpcfg_ent, spmpaddr: xlenbits, prev_spmpaddr: xlenbits) -> spmpMatch = {
  let rng = spmpAddrRange(ent, spmpaddr, prev_spmpaddr);
  match spmpMatchAddr(addr, width, rng) {
    SPMP_NoMatch      => SPMP_Continue,
    SPMP_PartialMatch => SPMP_Fail,
    SPMP_Match        => if   spmpCheckPerms(ent, acc, priv)
                        then SPMP_Success
                        else SPMP_Fail
  }
}

/* priority checks */

function spmpCheck forall 'n, 'n > 0. (addr: xlenbits, width: atom('n), acc: AccessType(ext_access_type), priv: Privilege)
                  -> option(ExceptionType) = {
  let width : xlenbits = to_bits(sizeof(xlen), width);
  let check : bool =
  match spmpMatchEntry(addr, width, acc, priv, spmp0cfg, spmpaddr0, zeros()) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp1cfg, spmpaddr1, spmpaddr0) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp2cfg, spmpaddr2, spmpaddr1) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp3cfg, spmpaddr3, spmpaddr2) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp4cfg, spmpaddr4, spmpaddr3) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp5cfg, spmpaddr5, spmpaddr4) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp6cfg, spmpaddr6, spmpaddr5) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp7cfg, spmpaddr7, spmpaddr6) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp8cfg, spmpaddr8, spmpaddr7) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp9cfg, spmpaddr9, spmpaddr8) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp10cfg, spmpaddr10, spmpaddr9) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp11cfg, spmpaddr11, spmpaddr10) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp12cfg, spmpaddr12, spmpaddr11) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp13cfg, spmpaddr13, spmpaddr12) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp14cfg, spmpaddr14, spmpaddr13) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp15cfg, spmpaddr15, spmpaddr14) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue => match priv {
                      User => false,
                      _       => true
                    }
  }}}}}}}}}}}}}}}};

  if   check
  then None()
  else match acc {
    Read(_)      => Some(E_Load_Page_Fault()),
    Write(_)     => Some(E_SAMO_Page_Fault()),
    ReadWrite(_) => Some(E_SAMO_Page_Fault()),
    Execute()    => Some(E_Fetch_Page_Fault())
  }
}

function init_spmp() -> unit = {
  spmp0cfg  = update_A(spmp0cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp1cfg  = update_A(spmp1cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp2cfg  = update_A(spmp2cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp3cfg  = update_A(spmp3cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp4cfg  = update_A(spmp4cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp5cfg  = update_A(spmp5cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp6cfg  = update_A(spmp6cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp7cfg  = update_A(spmp7cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp8cfg  = update_A(spmp8cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp9cfg  = update_A(spmp9cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp10cfg = update_A(spmp10cfg, spmpAddrMatchType_to_bits(OFF));
  spmp11cfg = update_A(spmp11cfg, spmpAddrMatchType_to_bits(OFF));
  spmp12cfg = update_A(spmp12cfg, spmpAddrMatchType_to_bits(OFF));
  spmp13cfg = update_A(spmp13cfg, spmpAddrMatchType_to_bits(OFF));
  spmp14cfg = update_A(spmp14cfg, spmpAddrMatchType_to_bits(OFF));
  spmp15cfg = update_A(spmp15cfg, spmpAddrMatchType_to_bits(OFF))
}
