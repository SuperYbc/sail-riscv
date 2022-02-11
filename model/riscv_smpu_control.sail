/* address ranges */
/* [min, max) of the matching range. */
type smpu_addr_range = option((xlenbits, xlenbits))

function smpuAddrRange(cfg: Smpucfg_ent, smpuaddr: xlenbits, prev_smpuaddr: xlenbits) -> smpu_addr_range = {
  match smpuAddrMatchType_of_bits(cfg.A()) {
    OFF   => None(),
    TOR   => { Some ((prev_smpuaddr << 2, smpuaddr << 2)) },
    NA4   => { let lo = smpuaddr << 2;
               Some((lo, lo + 4))
             },
    NAPOT => { let mask = smpuaddr ^ (smpuaddr + 1);  // generate 1s in signifying bits
               let lo   = smpuaddr & (~ (mask));
               let len  = mask + 1;
               Some((lo << 2, (lo + len) << 2))
             }
  }
}

/* permission checks */
val CheckRWX: (Smpucfg_ent, AccessType(ext_access_type), Privilege) -> bool
function CheckRWX(ent, acc, priv) = {
  match acc {
    Read(_)      => ent.R() == 0b1,
    Write(_)     => ent.W() == 0b1,
    ReadWrite(_) => ent.R() == 0b1 & ent.W() == 0b1,
    Execute()    => ent.X() == 0b1
  }
}

val smpuCheckRWX: (Smpucfg_ent, AccessType(ext_access_type), Privilege) -> bool effect {rreg}
function smpuCheckRWX(ent, acc, priv) = {
  let do_sum : bool = mstatus.SUM() == 0b1;

  match (ent.S(), ent.R(), ent.W(), ent.X()) {
    (0b0, 0b0, 0b0, 0b0) => false,
    (0b0, 0b0, 0b0, 0b1) => priv == User & CheckRWX(ent, acc, priv),
    (0b0, 0b0, 0b1, 0b0) => (priv == User & acc == Read()) | (priv == Supervisor & acc != Execute()),
    (0b0, 0b0, 0b1, 0b1) => acc != Execute(),
    (0b0, 0b1, 0b0, 0b0) => (priv == User | (priv == Supervisor & do_sum)) & CheckRWX(ent, acc, priv),
    (0b0, 0b1, 0b0, 0b1) => (priv == User | (priv == Supervisor & do_sum & acc != Execute())) & CheckRWX(ent, acc, priv),
    (0b0, 0b1, 0b1, 0b0) => (priv == User | (priv == Supervisor & do_sum)) & CheckRWX(ent, acc, priv),
    (0b0, 0b1, 0b1, 0b1) => (priv == User | (priv == Supervisor & do_sum & acc != Execute())) & CheckRWX(ent, acc, priv),
    (0b1, 0b0, 0b0, 0b0) => false,
    (0b1, 0b0, 0b0, 0b1) => priv == Supervisor & CheckRWX(ent, acc, priv),
    (0b1, 0b0, 0b1, 0b0) => acc == Execute(),
    (0b1, 0b0, 0b1, 0b1) => (priv == User & acc == Execute()) | (priv == Supervisor & acc != Write()),
    (0b1, 0b1, 0b0, 0b0) => priv == Supervisor & CheckRWX(ent, acc, priv),
    (0b1, 0b1, 0b0, 0b1) => priv == Supervisor & CheckRWX(ent, acc, priv),
    (0b1, 0b1, 0b1, 0b0) => priv == Supervisor & CheckRWX(ent, acc, priv),
    (0b1, 0b1, 0b1, 0b1) => acc == Read()
  }
}

// this needs to be called with the effective current privilege.
val smpuCheckPerms: (Smpucfg_ent, AccessType(ext_access_type), Privilege) -> bool effect {rreg}
function smpuCheckPerms(ent, acc, priv) = {
  match priv {
    Machine => true,
    _       => smpuCheckRWX(ent, acc, priv)
  }
}

/* matching logic */

enum smpuAddrMatch = {SMPU_NoMatch, SMPU_PartialMatch, SMPU_Match}

function smpuMatchAddr(addr: xlenbits, width: xlenbits, rng: smpu_addr_range) -> smpuAddrMatch = {
  match rng {
    None()         => SMPU_NoMatch,
    Some((lo, hi)) => if   hi <_u lo   /* to handle mis-configuration */
                      then SMPU_NoMatch
                      else {
                        if      (addr + width <=_u lo) | (hi <=_u addr)
                        then    SMPU_NoMatch
                        else if (lo <=_u addr) & (addr + width <=_u hi)
                        then    SMPU_Match
                        else    SMPU_PartialMatch
                      }
  }
}

enum smpuMatch = {SMPU_Success, SMPU_Continue, SMPU_Fail}

function smpuMatchEntry(addr: xlenbits, width: xlenbits, acc: AccessType(ext_access_type), priv: Privilege,
                       ent: Smpucfg_ent, smpuaddr: xlenbits, prev_smpuaddr: xlenbits) -> smpuMatch = {
  let rng = smpuAddrRange(ent, smpuaddr, prev_smpuaddr);
  match smpuMatchAddr(addr, width, rng) {
    SMPU_NoMatch      => SMPU_Continue,
    SMPU_PartialMatch => SMPU_Fail,
    SMPU_Match        => if   smpuCheckPerms(ent, acc, priv)
                        then SMPU_Success
                        else SMPU_Fail
  }
}

/* priority checks */

function smpuCheck forall 'n, 'n > 0. (addr: xlenbits, width: atom('n), acc: AccessType(ext_access_type), priv: Privilege)
                  -> option(ExceptionType) = {
  let width : xlenbits = to_bits(sizeof(xlen), width);
  let check : bool =
  match smpuMatchEntry(addr, width, acc, priv, smpu0cfg, smpuaddr0, zeros()) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu1cfg, smpuaddr1, smpuaddr0) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu2cfg, smpuaddr2, smpuaddr1) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu3cfg, smpuaddr3, smpuaddr2) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu4cfg, smpuaddr4, smpuaddr3) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu5cfg, smpuaddr5, smpuaddr4) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu6cfg, smpuaddr6, smpuaddr5) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu7cfg, smpuaddr7, smpuaddr6) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu8cfg, smpuaddr8, smpuaddr7) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu9cfg, smpuaddr9, smpuaddr8) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu10cfg, smpuaddr10, smpuaddr9) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu11cfg, smpuaddr11, smpuaddr10) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu12cfg, smpuaddr12, smpuaddr11) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu13cfg, smpuaddr13, smpuaddr12) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu14cfg, smpuaddr14, smpuaddr13) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu15cfg, smpuaddr15, smpuaddr14) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue => 
  match smpuMatchEntry(addr, width, acc, priv, smpu16cfg, smpuaddr16, smpuaddr15) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu17cfg, smpuaddr17, smpuaddr16) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu18cfg, smpuaddr18, smpuaddr17) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu19cfg, smpuaddr19, smpuaddr18) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu20cfg, smpuaddr20, smpuaddr19) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu21cfg, smpuaddr21, smpuaddr20) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu22cfg, smpuaddr22, smpuaddr21) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu23cfg, smpuaddr23, smpuaddr22) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu24cfg, smpuaddr24, smpuaddr23) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu25cfg, smpuaddr25, smpuaddr24) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu26cfg, smpuaddr26, smpuaddr25) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu27cfg, smpuaddr27, smpuaddr26) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu28cfg, smpuaddr28, smpuaddr27) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu29cfg, smpuaddr29, smpuaddr28) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu30cfg, smpuaddr30, smpuaddr29) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu31cfg, smpuaddr31, smpuaddr30) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue => 
  match smpuMatchEntry(addr, width, acc, priv, smpu32cfg, smpuaddr32, smpuaddr31) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu33cfg, smpuaddr33, smpuaddr32) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu34cfg, smpuaddr34, smpuaddr33) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu35cfg, smpuaddr35, smpuaddr34) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu36cfg, smpuaddr36, smpuaddr35) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu37cfg, smpuaddr37, smpuaddr36) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu38cfg, smpuaddr38, smpuaddr37) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu39cfg, smpuaddr39, smpuaddr38) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu40cfg, smpuaddr40, smpuaddr39) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu41cfg, smpuaddr41, smpuaddr40) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu42cfg, smpuaddr42, smpuaddr41) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu43cfg, smpuaddr43, smpuaddr42) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu44cfg, smpuaddr44, smpuaddr43) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu45cfg, smpuaddr45, smpuaddr44) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu46cfg, smpuaddr46, smpuaddr45) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu47cfg, smpuaddr47, smpuaddr46) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue => 
  match smpuMatchEntry(addr, width, acc, priv, smpu48cfg, smpuaddr48, smpuaddr47) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu49cfg, smpuaddr49, smpuaddr48) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu50cfg, smpuaddr50, smpuaddr49) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu51cfg, smpuaddr51, smpuaddr50) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu52cfg, smpuaddr52, smpuaddr51) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu53cfg, smpuaddr53, smpuaddr52) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu54cfg, smpuaddr54, smpuaddr53) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu55cfg, smpuaddr55, smpuaddr54) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu56cfg, smpuaddr56, smpuaddr55) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu57cfg, smpuaddr57, smpuaddr56) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu58cfg, smpuaddr58, smpuaddr57) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu59cfg, smpuaddr59, smpuaddr58) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu60cfg, smpuaddr60, smpuaddr59) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu61cfg, smpuaddr61, smpuaddr60) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu62cfg, smpuaddr62, smpuaddr61) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue =>
  match smpuMatchEntry(addr, width, acc, priv, smpu63cfg, smpuaddr63, smpuaddr62) {
    SMPU_Success  => true,
    SMPU_Fail     => false,
    SMPU_Continue => match priv {
                      User => false,
                      _    => true
                    }
  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}};

/* 
 * The SMPU is proposing to rename page fault to SMPU/Sv fault for clarity.
 * Since SMPU is not merged into spec, so it remains page fault here.
 */    
  if   check
  then None()
  else match acc {
    Read(_)      => Some(E_Load_Page_Fault()),
    Write(_)     => Some(E_SAMO_Page_Fault()),
    ReadWrite(_) => Some(E_SAMO_Page_Fault()),
    Execute()    => Some(E_Fetch_Page_Fault())
  }
}

function init_smpu() -> unit = {
  smpu0cfg  = update_A(smpu0cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu1cfg  = update_A(smpu1cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu2cfg  = update_A(smpu2cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu3cfg  = update_A(smpu3cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu4cfg  = update_A(smpu4cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu5cfg  = update_A(smpu5cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu6cfg  = update_A(smpu6cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu7cfg  = update_A(smpu7cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu8cfg  = update_A(smpu8cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu9cfg  = update_A(smpu9cfg,  smpuAddrMatchType_to_bits(OFF));
  smpu10cfg = update_A(smpu10cfg, smpuAddrMatchType_to_bits(OFF));
  smpu11cfg = update_A(smpu11cfg, smpuAddrMatchType_to_bits(OFF));
  smpu12cfg = update_A(smpu12cfg, smpuAddrMatchType_to_bits(OFF));
  smpu13cfg = update_A(smpu13cfg, smpuAddrMatchType_to_bits(OFF));
  smpu14cfg = update_A(smpu14cfg, smpuAddrMatchType_to_bits(OFF));
  smpu15cfg = update_A(smpu15cfg, smpuAddrMatchType_to_bits(OFF));
  smpu16cfg = update_A(smpu16cfg, smpuAddrMatchType_to_bits(OFF));
  smpu17cfg = update_A(smpu17cfg, smpuAddrMatchType_to_bits(OFF));
  smpu18cfg = update_A(smpu18cfg, smpuAddrMatchType_to_bits(OFF));
  smpu19cfg = update_A(smpu19cfg, smpuAddrMatchType_to_bits(OFF));
  smpu20cfg = update_A(smpu20cfg, smpuAddrMatchType_to_bits(OFF));
  smpu21cfg = update_A(smpu21cfg, smpuAddrMatchType_to_bits(OFF));
  smpu22cfg = update_A(smpu22cfg, smpuAddrMatchType_to_bits(OFF));
  smpu23cfg = update_A(smpu23cfg, smpuAddrMatchType_to_bits(OFF));
  smpu24cfg = update_A(smpu24cfg, smpuAddrMatchType_to_bits(OFF));
  smpu25cfg = update_A(smpu25cfg, smpuAddrMatchType_to_bits(OFF));
  smpu26cfg = update_A(smpu26cfg, smpuAddrMatchType_to_bits(OFF));
  smpu27cfg = update_A(smpu27cfg, smpuAddrMatchType_to_bits(OFF));
  smpu28cfg = update_A(smpu28cfg, smpuAddrMatchType_to_bits(OFF));
  smpu29cfg = update_A(smpu29cfg, smpuAddrMatchType_to_bits(OFF));
  smpu30cfg = update_A(smpu30cfg, smpuAddrMatchType_to_bits(OFF));
  smpu31cfg = update_A(smpu31cfg, smpuAddrMatchType_to_bits(OFF));
  smpu32cfg = update_A(smpu32cfg, smpuAddrMatchType_to_bits(OFF));
  smpu33cfg = update_A(smpu33cfg, smpuAddrMatchType_to_bits(OFF));
  smpu34cfg = update_A(smpu34cfg, smpuAddrMatchType_to_bits(OFF));
  smpu35cfg = update_A(smpu35cfg, smpuAddrMatchType_to_bits(OFF));
  smpu36cfg = update_A(smpu36cfg, smpuAddrMatchType_to_bits(OFF));
  smpu37cfg = update_A(smpu37cfg, smpuAddrMatchType_to_bits(OFF));
  smpu38cfg = update_A(smpu38cfg, smpuAddrMatchType_to_bits(OFF));
  smpu39cfg = update_A(smpu39cfg, smpuAddrMatchType_to_bits(OFF));
  smpu40cfg = update_A(smpu40cfg, smpuAddrMatchType_to_bits(OFF));
  smpu41cfg = update_A(smpu41cfg, smpuAddrMatchType_to_bits(OFF));
  smpu42cfg = update_A(smpu42cfg, smpuAddrMatchType_to_bits(OFF));
  smpu43cfg = update_A(smpu43cfg, smpuAddrMatchType_to_bits(OFF));
  smpu44cfg = update_A(smpu44cfg, smpuAddrMatchType_to_bits(OFF));
  smpu45cfg = update_A(smpu45cfg, smpuAddrMatchType_to_bits(OFF));
  smpu46cfg = update_A(smpu46cfg, smpuAddrMatchType_to_bits(OFF));
  smpu47cfg = update_A(smpu47cfg, smpuAddrMatchType_to_bits(OFF));
  smpu48cfg = update_A(smpu48cfg, smpuAddrMatchType_to_bits(OFF));
  smpu49cfg = update_A(smpu49cfg, smpuAddrMatchType_to_bits(OFF));
  smpu50cfg = update_A(smpu50cfg, smpuAddrMatchType_to_bits(OFF));
  smpu51cfg = update_A(smpu51cfg, smpuAddrMatchType_to_bits(OFF));
  smpu52cfg = update_A(smpu52cfg, smpuAddrMatchType_to_bits(OFF));
  smpu53cfg = update_A(smpu53cfg, smpuAddrMatchType_to_bits(OFF));
  smpu54cfg = update_A(smpu54cfg, smpuAddrMatchType_to_bits(OFF));
  smpu55cfg = update_A(smpu55cfg, smpuAddrMatchType_to_bits(OFF));
  smpu56cfg = update_A(smpu56cfg, smpuAddrMatchType_to_bits(OFF));
  smpu57cfg = update_A(smpu57cfg, smpuAddrMatchType_to_bits(OFF));
  smpu58cfg = update_A(smpu58cfg, smpuAddrMatchType_to_bits(OFF));
  smpu59cfg = update_A(smpu59cfg, smpuAddrMatchType_to_bits(OFF));
  smpu60cfg = update_A(smpu60cfg, smpuAddrMatchType_to_bits(OFF));
  smpu61cfg = update_A(smpu61cfg, smpuAddrMatchType_to_bits(OFF));
  smpu62cfg = update_A(smpu62cfg, smpuAddrMatchType_to_bits(OFF));
  smpu63cfg = update_A(smpu63cfg, smpuAddrMatchType_to_bits(OFF));

  /* For backwards compatibility with software that is unaware of SMPU,
    initialize SMPU to permit unprivileged access to all of memory. */
  // smpuWriteCfgReg(2, 0b1000100000000000000000000000000000000000000000000000000000000000);
  // smpuaddr63 = smpuWriteAddr(smpuaddr63, 0b1111111111111111111111111111111111111111111111111111111111111111)
}
