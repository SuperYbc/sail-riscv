/* SPMP configuration entries */

// enum PmpAddrMatchType = {OFF, TOR, NA4, NAPOT}

val spmpAddrMatchType_of_bits : bits(2) -> PmpAddrMatchType
function spmpAddrMatchType_of_bits(bs) = {
  match bs {
    0b00 => OFF,
    0b01 => TOR,
    0b10 => NA4,
    0b11 => NAPOT
  }
}

val spmpAddrMatchType_to_bits : PmpAddrMatchType -> bits(2)
function spmpAddrMatchType_to_bits(bs) = {
  match bs {
    OFF   => 0b00,
    TOR   => 0b01,
    NA4   => 0b10,
    NAPOT => 0b11
  }
}

bitfield Spmpcfg_ent : bits(8) = {
  S : 7,        /* S-mode */
  A : 4 .. 3,   /* address match type, encoded as above */

  /* permissions */
  X : 2,        /* execute */
  W : 1,        /* write */
  R : 0         /* read */
}

register spmp0cfg  : Spmpcfg_ent
register spmp1cfg  : Spmpcfg_ent
register spmp2cfg  : Spmpcfg_ent
register spmp3cfg  : Spmpcfg_ent
register spmp4cfg  : Spmpcfg_ent
register spmp5cfg  : Spmpcfg_ent
register spmp6cfg  : Spmpcfg_ent
register spmp7cfg  : Spmpcfg_ent
register spmp8cfg  : Spmpcfg_ent
register spmp9cfg  : Spmpcfg_ent
register spmp10cfg : Spmpcfg_ent
register spmp11cfg : Spmpcfg_ent
register spmp12cfg : Spmpcfg_ent
register spmp13cfg : Spmpcfg_ent
register spmp14cfg : Spmpcfg_ent
register spmp15cfg : Spmpcfg_ent

/* SPMP address configuration */

register spmpaddr0  : xlenbits
register spmpaddr1  : xlenbits
register spmpaddr2  : xlenbits
register spmpaddr3  : xlenbits
register spmpaddr4  : xlenbits
register spmpaddr5  : xlenbits
register spmpaddr6  : xlenbits
register spmpaddr7  : xlenbits
register spmpaddr8  : xlenbits
register spmpaddr9  : xlenbits
register spmpaddr10 : xlenbits
register spmpaddr11 : xlenbits
register spmpaddr12 : xlenbits
register spmpaddr13 : xlenbits
register spmpaddr14 : xlenbits
register spmpaddr15 : xlenbits

/* Packing and unpacking spmpcfg regs for xlen-width accesses */

val spmpReadCfgReg : forall 'n, 0 <= 'n < 4 . (atom('n)) -> xlenbits effect {rreg}
function spmpReadCfgReg(n) = {
  if   sizeof(xlen) == 32
  then match n {
         0 => append(spmp3cfg.bits(),  append(spmp2cfg.bits(),  append(spmp1cfg.bits(),  spmp0cfg.bits()))),
         1 => append(spmp7cfg.bits(),  append(spmp6cfg.bits(),  append(spmp5cfg.bits(),  spmp4cfg.bits()))),
         2 => append(spmp11cfg.bits(), append(spmp10cfg.bits(), append(spmp9cfg.bits(),  spmp8cfg.bits()))),
         3 => append(spmp15cfg.bits(), append(spmp14cfg.bits(), append(spmp13cfg.bits(), spmp12cfg.bits())))
       }
  else match n { //  sizeof(xlen) == 64
         0 => append(spmp7cfg.bits(),  append(spmp6cfg.bits(),  append(spmp5cfg.bits(),  append(spmp4cfg.bits(),  append(spmp3cfg.bits(),  append(spmp2cfg.bits(),  append(spmp1cfg.bits(),  spmp0cfg.bits()))))))),
         2 => append(spmp15cfg.bits(), append(spmp14cfg.bits(), append(spmp13cfg.bits(), append(spmp12cfg.bits(), append(spmp11cfg.bits(), append(spmp10cfg.bits(), append(spmp9cfg.bits(),  spmp8cfg.bits())))))))
       }
}

function spmpWriteCfg(cfg: Spmpcfg_ent, v: bits(8)) -> Spmpcfg_ent =
  Mk_Spmpcfg_ent(v & 0x9f)  // Bits 5 and 6 are zero.

val spmpWriteCfgReg : forall 'n, 0 <= 'n < 4 . (atom('n), xlenbits) -> unit effect {rreg, wreg}
function spmpWriteCfgReg(n, v) = {
  if   sizeof(xlen) == 32
  then match n {
         0 => { spmp0cfg  = spmpWriteCfg(spmp0cfg,  v[7 ..0]);
                spmp1cfg  = spmpWriteCfg(spmp1cfg,  v[15..8]);
                spmp2cfg  = spmpWriteCfg(spmp2cfg,  v[23..16]);
                spmp3cfg  = spmpWriteCfg(spmp3cfg,  v[31..24]);
              },
         1 => { spmp4cfg  = spmpWriteCfg(spmp4cfg,  v[7 ..0]);
                spmp5cfg  = spmpWriteCfg(spmp5cfg,  v[15..8]);
                spmp6cfg  = spmpWriteCfg(spmp6cfg,  v[23..16]);
                spmp7cfg  = spmpWriteCfg(spmp7cfg,  v[31..24]);
              },
         2 => { spmp8cfg  = spmpWriteCfg(spmp8cfg,  v[7 ..0]);
                spmp9cfg  = spmpWriteCfg(spmp9cfg,  v[15..8]);
                spmp10cfg = spmpWriteCfg(spmp10cfg, v[23..16]);
                spmp11cfg = spmpWriteCfg(spmp11cfg, v[31..24]);
              },
         3 => { spmp12cfg = spmpWriteCfg(spmp12cfg, v[7 ..0]);
                spmp13cfg = spmpWriteCfg(spmp13cfg, v[15..8]);
                spmp14cfg = spmpWriteCfg(spmp14cfg, v[23..16]);
                spmp15cfg = spmpWriteCfg(spmp15cfg, v[31..24]);
              }
       }
  else if sizeof(xlen) == 64
  then match n {
         0 => { spmp0cfg  = spmpWriteCfg(spmp0cfg,  v[7 ..0]);
                spmp1cfg  = spmpWriteCfg(spmp1cfg,  v[15..8]);
                spmp2cfg  = spmpWriteCfg(spmp2cfg,  v[23..16]);
                spmp3cfg  = spmpWriteCfg(spmp3cfg,  v[31..24]);
                spmp4cfg  = spmpWriteCfg(spmp4cfg,  v[39..32]);
                spmp5cfg  = spmpWriteCfg(spmp5cfg,  v[47..40]);
                spmp6cfg  = spmpWriteCfg(spmp6cfg,  v[55..48]);
                spmp7cfg  = spmpWriteCfg(spmp7cfg,  v[63..56])
              },
         2 => { spmp8cfg  = spmpWriteCfg(spmp8cfg,  v[7 ..0]);
                spmp9cfg  = spmpWriteCfg(spmp9cfg,  v[15..8]);
                spmp10cfg = spmpWriteCfg(spmp10cfg, v[23..16]);
                spmp11cfg = spmpWriteCfg(spmp11cfg, v[31..24]);
                spmp12cfg = spmpWriteCfg(spmp12cfg, v[39..32]);
                spmp13cfg = spmpWriteCfg(spmp13cfg, v[47..40]);
                spmp14cfg = spmpWriteCfg(spmp14cfg, v[55..48]);
                spmp15cfg = spmpWriteCfg(spmp15cfg, v[63..56])
              }
       }
}

function spmpWriteAddr(reg: xlenbits, v: xlenbits) -> xlenbits =
  if   sizeof(xlen) == 32
  then { v }
  else { EXTZ(v[53..0]) }
