/* SMPU configuration entries */

/* Reuse PmpAddrMatchType */
// enum PmpAddrMatchType = {OFF, TOR, NA4, NAPOT}

val smpuAddrMatchType_of_bits : bits(2) -> PmpAddrMatchType
function smpuAddrMatchType_of_bits(bs) = {
  match bs {
    0b00 => OFF,
    0b01 => TOR,
    0b10 => NA4,
    0b11 => NAPOT
  }
}

val smpuAddrMatchType_to_bits : PmpAddrMatchType -> bits(2)
function smpuAddrMatchType_to_bits(bs) = {
  match bs {
    OFF   => 0b00,
    TOR   => 0b01,
    NA4   => 0b10,
    NAPOT => 0b11
  }
}

bitfield Smpucfg_ent : bits(8) = {
  S : 7,        /* S-mode */
  A : 4 .. 3,   /* address match type, encoded as above */

  /* permissions */
  X : 2,        /* execute */
  W : 1,        /* write */
  R : 0         /* read */
}

register smpu0cfg  : Smpucfg_ent
register smpu1cfg  : Smpucfg_ent
register smpu2cfg  : Smpucfg_ent
register smpu3cfg  : Smpucfg_ent
register smpu4cfg  : Smpucfg_ent
register smpu5cfg  : Smpucfg_ent
register smpu6cfg  : Smpucfg_ent
register smpu7cfg  : Smpucfg_ent
register smpu8cfg  : Smpucfg_ent
register smpu9cfg  : Smpucfg_ent
register smpu10cfg : Smpucfg_ent
register smpu11cfg : Smpucfg_ent
register smpu12cfg : Smpucfg_ent
register smpu13cfg : Smpucfg_ent
register smpu14cfg : Smpucfg_ent
register smpu15cfg : Smpucfg_ent
register smpu16cfg : Smpucfg_ent
register smpu17cfg : Smpucfg_ent
register smpu18cfg : Smpucfg_ent
register smpu19cfg : Smpucfg_ent
register smpu20cfg : Smpucfg_ent
register smpu21cfg : Smpucfg_ent
register smpu22cfg : Smpucfg_ent
register smpu23cfg : Smpucfg_ent
register smpu24cfg : Smpucfg_ent
register smpu25cfg : Smpucfg_ent
register smpu26cfg : Smpucfg_ent
register smpu27cfg : Smpucfg_ent
register smpu28cfg : Smpucfg_ent
register smpu29cfg : Smpucfg_ent
register smpu30cfg : Smpucfg_ent
register smpu31cfg : Smpucfg_ent
register smpu32cfg : Smpucfg_ent
register smpu33cfg : Smpucfg_ent
register smpu34cfg : Smpucfg_ent
register smpu35cfg : Smpucfg_ent
register smpu36cfg : Smpucfg_ent
register smpu37cfg : Smpucfg_ent
register smpu38cfg : Smpucfg_ent
register smpu39cfg : Smpucfg_ent
register smpu40cfg : Smpucfg_ent
register smpu41cfg : Smpucfg_ent
register smpu42cfg : Smpucfg_ent
register smpu43cfg : Smpucfg_ent
register smpu44cfg : Smpucfg_ent
register smpu45cfg : Smpucfg_ent
register smpu46cfg : Smpucfg_ent
register smpu47cfg : Smpucfg_ent
register smpu48cfg : Smpucfg_ent
register smpu49cfg : Smpucfg_ent
register smpu50cfg : Smpucfg_ent
register smpu51cfg : Smpucfg_ent
register smpu52cfg : Smpucfg_ent
register smpu53cfg : Smpucfg_ent
register smpu54cfg : Smpucfg_ent
register smpu55cfg : Smpucfg_ent
register smpu56cfg : Smpucfg_ent
register smpu57cfg : Smpucfg_ent
register smpu58cfg : Smpucfg_ent
register smpu59cfg : Smpucfg_ent
register smpu60cfg : Smpucfg_ent
register smpu61cfg : Smpucfg_ent
register smpu62cfg : Smpucfg_ent
register smpu63cfg : Smpucfg_ent

/* SMPU address configuration */

register smpuaddr0  : xlenbits
register smpuaddr1  : xlenbits
register smpuaddr2  : xlenbits
register smpuaddr3  : xlenbits
register smpuaddr4  : xlenbits
register smpuaddr5  : xlenbits
register smpuaddr6  : xlenbits
register smpuaddr7  : xlenbits
register smpuaddr8  : xlenbits
register smpuaddr9  : xlenbits
register smpuaddr10 : xlenbits
register smpuaddr11 : xlenbits
register smpuaddr12 : xlenbits
register smpuaddr13 : xlenbits
register smpuaddr14 : xlenbits
register smpuaddr15 : xlenbits
register smpuaddr16 : xlenbits
register smpuaddr17 : xlenbits
register smpuaddr18 : xlenbits
register smpuaddr19 : xlenbits
register smpuaddr20 : xlenbits
register smpuaddr21 : xlenbits
register smpuaddr22 : xlenbits
register smpuaddr23 : xlenbits
register smpuaddr24 : xlenbits
register smpuaddr25 : xlenbits
register smpuaddr26 : xlenbits
register smpuaddr27 : xlenbits
register smpuaddr28 : xlenbits
register smpuaddr29 : xlenbits
register smpuaddr30 : xlenbits
register smpuaddr31 : xlenbits
register smpuaddr32 : xlenbits
register smpuaddr33 : xlenbits
register smpuaddr34 : xlenbits
register smpuaddr35 : xlenbits
register smpuaddr36 : xlenbits
register smpuaddr37 : xlenbits
register smpuaddr38 : xlenbits
register smpuaddr39 : xlenbits
register smpuaddr40 : xlenbits
register smpuaddr41 : xlenbits
register smpuaddr42 : xlenbits
register smpuaddr43 : xlenbits
register smpuaddr44 : xlenbits
register smpuaddr45 : xlenbits
register smpuaddr46 : xlenbits
register smpuaddr47 : xlenbits
register smpuaddr48 : xlenbits
register smpuaddr49 : xlenbits
register smpuaddr50 : xlenbits
register smpuaddr51 : xlenbits
register smpuaddr52 : xlenbits
register smpuaddr53 : xlenbits
register smpuaddr54 : xlenbits
register smpuaddr55 : xlenbits
register smpuaddr56 : xlenbits
register smpuaddr57 : xlenbits
register smpuaddr58 : xlenbits
register smpuaddr59 : xlenbits
register smpuaddr60 : xlenbits
register smpuaddr61 : xlenbits
register smpuaddr62 : xlenbits
register smpuaddr63 : xlenbits

/* Packing and unpacking smpucfg regs for xlen-width accesses */

val smpuReadCfgReg : forall 'n, 0 <= 'n < 16 . (atom('n)) -> xlenbits effect {rreg}
function smpuReadCfgReg(n) = {
  if   sizeof(xlen) == 32
  then match n {
         0  => append(smpu3cfg.bits(),  append(smpu2cfg.bits(),  append(smpu1cfg.bits(),  smpu0cfg.bits()))),
         1  => append(smpu7cfg.bits(),  append(smpu6cfg.bits(),  append(smpu5cfg.bits(),  smpu4cfg.bits()))),
         2  => append(smpu11cfg.bits(), append(smpu10cfg.bits(), append(smpu9cfg.bits(),  smpu8cfg.bits()))),
         3  => append(smpu15cfg.bits(), append(smpu14cfg.bits(), append(smpu13cfg.bits(), smpu12cfg.bits()))),
         4  => append(smpu19cfg.bits(), append(smpu18cfg.bits(), append(smpu17cfg.bits(), smpu16cfg.bits()))),
         5  => append(smpu23cfg.bits(), append(smpu22cfg.bits(), append(smpu21cfg.bits(), smpu20cfg.bits()))),
         6  => append(smpu27cfg.bits(), append(smpu26cfg.bits(), append(smpu25cfg.bits(), smpu24cfg.bits()))),
         7  => append(smpu31cfg.bits(), append(smpu30cfg.bits(), append(smpu29cfg.bits(), smpu28cfg.bits()))),
         8  => append(smpu35cfg.bits(), append(smpu34cfg.bits(), append(smpu33cfg.bits(), smpu32cfg.bits()))),
         9  => append(smpu39cfg.bits(), append(smpu38cfg.bits(), append(smpu37cfg.bits(), smpu36cfg.bits()))),
         10 => append(smpu43cfg.bits(), append(smpu42cfg.bits(), append(smpu41cfg.bits(), smpu40cfg.bits()))),
         11 => append(smpu47cfg.bits(), append(smpu46cfg.bits(), append(smpu45cfg.bits(), smpu44cfg.bits()))),
         12 => append(smpu51cfg.bits(), append(smpu50cfg.bits(), append(smpu49cfg.bits(), smpu48cfg.bits()))),
         13 => append(smpu55cfg.bits(), append(smpu54cfg.bits(), append(smpu53cfg.bits(), smpu52cfg.bits()))),
         14 => append(smpu59cfg.bits(), append(smpu58cfg.bits(), append(smpu57cfg.bits(), smpu56cfg.bits()))),
         15 => append(smpu63cfg.bits(), append(smpu62cfg.bits(), append(smpu61cfg.bits(), smpu60cfg.bits())))
       }
  else match n { //  sizeof(xlen) == 64
         0  => append(smpu7cfg.bits(),  append(smpu6cfg.bits(),  append(smpu5cfg.bits(),  append(smpu4cfg.bits(),  append(smpu3cfg.bits(),  append(smpu2cfg.bits(),  append(smpu1cfg.bits(),  smpu0cfg.bits()))))))),
         2  => append(smpu15cfg.bits(), append(smpu14cfg.bits(), append(smpu13cfg.bits(), append(smpu12cfg.bits(), append(smpu11cfg.bits(), append(smpu10cfg.bits(), append(smpu9cfg.bits(),  smpu8cfg.bits()))))))),
         4  => append(smpu23cfg.bits(), append(smpu22cfg.bits(), append(smpu21cfg.bits(), append(smpu20cfg.bits(), append(smpu19cfg.bits(), append(smpu18cfg.bits(), append(smpu17cfg.bits(), smpu16cfg.bits()))))))),
         6  => append(smpu31cfg.bits(), append(smpu30cfg.bits(), append(smpu29cfg.bits(), append(smpu28cfg.bits(), append(smpu27cfg.bits(), append(smpu26cfg.bits(), append(smpu25cfg.bits(), smpu24cfg.bits()))))))),
         8  => append(smpu39cfg.bits(), append(smpu38cfg.bits(), append(smpu37cfg.bits(), append(smpu36cfg.bits(), append(smpu35cfg.bits(), append(smpu34cfg.bits(), append(smpu33cfg.bits(), smpu32cfg.bits()))))))),
         10 => append(smpu47cfg.bits(), append(smpu46cfg.bits(), append(smpu45cfg.bits(), append(smpu44cfg.bits(), append(smpu43cfg.bits(), append(smpu42cfg.bits(), append(smpu41cfg.bits(), smpu40cfg.bits()))))))),
         12 => append(smpu55cfg.bits(), append(smpu54cfg.bits(), append(smpu53cfg.bits(), append(smpu52cfg.bits(), append(smpu51cfg.bits(), append(smpu50cfg.bits(), append(smpu49cfg.bits(), smpu48cfg.bits()))))))),
         14 => append(smpu63cfg.bits(), append(smpu62cfg.bits(), append(smpu61cfg.bits(), append(smpu60cfg.bits(), append(smpu59cfg.bits(), append(smpu58cfg.bits(), append(smpu57cfg.bits(), smpu56cfg.bits())))))))
       }
}

/* Helpers to handle S mode regions */
// function mpuSmodeRegion(cfg: Smpucfg_ent) -> bool =
//    cfg.S() == 0b1

function smpuWriteCfg(cfg: Smpucfg_ent, v: bits(8)) -> Smpucfg_ent =
  Mk_Smpucfg_ent(v & 0x9f)  // Bits 5 and 6 are zero.

val smpuWriteCfgReg : forall 'n, 0 <= 'n < 16 . (atom('n), xlenbits) -> unit effect {rreg, wreg}
function smpuWriteCfgReg(n, v) = {
  if   sizeof(xlen) == 32
  then match n {
         0 => { smpu0cfg   = smpuWriteCfg(smpu0cfg,  v[7 ..0]);
                smpu1cfg   = smpuWriteCfg(smpu1cfg,  v[15..8]);
                smpu2cfg   = smpuWriteCfg(smpu2cfg,  v[23..16]);
                smpu3cfg   = smpuWriteCfg(smpu3cfg,  v[31..24]);
              },
         1 => { smpu4cfg   = smpuWriteCfg(smpu4cfg,  v[7 ..0]);
                smpu5cfg   = smpuWriteCfg(smpu5cfg,  v[15..8]);
                smpu6cfg   = smpuWriteCfg(smpu6cfg,  v[23..16]);
                smpu7cfg   = smpuWriteCfg(smpu7cfg,  v[31..24]);
              },
         2 => { smpu8cfg   = smpuWriteCfg(smpu8cfg,  v[7 ..0]);
                smpu9cfg   = smpuWriteCfg(smpu9cfg,  v[15..8]);
                smpu10cfg  = smpuWriteCfg(smpu10cfg, v[23..16]);
                smpu11cfg  = smpuWriteCfg(smpu11cfg, v[31..24]);
              },
         3 => { smpu12cfg  = smpuWriteCfg(smpu12cfg, v[7 ..0]);
                smpu13cfg  = smpuWriteCfg(smpu13cfg, v[15..8]);
                smpu14cfg  = smpuWriteCfg(smpu14cfg, v[23..16]);
                smpu15cfg  = smpuWriteCfg(smpu15cfg, v[31..24]);
              },
         4 => { smpu16cfg  = smpuWriteCfg(smpu16cfg, v[7 ..0]);
                smpu17cfg  = smpuWriteCfg(smpu17cfg, v[15..8]);
                smpu18cfg  = smpuWriteCfg(smpu18cfg, v[23..16]);
                smpu19cfg  = smpuWriteCfg(smpu19cfg, v[31..24]);
              },
         5 => { smpu20cfg  = smpuWriteCfg(smpu20cfg, v[7 ..0]);
                smpu21cfg  = smpuWriteCfg(smpu21cfg, v[15..8]);
                smpu22cfg  = smpuWriteCfg(smpu22cfg, v[23..16]);
                smpu23cfg  = smpuWriteCfg(smpu23cfg, v[31..24]);
              },
         6 => { smpu24cfg  = smpuWriteCfg(smpu24cfg, v[7 ..0]);
                smpu25cfg  = smpuWriteCfg(smpu25cfg, v[15..8]);
                smpu26cfg  = smpuWriteCfg(smpu26cfg, v[23..16]);
                smpu27cfg  = smpuWriteCfg(smpu27cfg, v[31..24]);
              },
         7 => { smpu28cfg  = smpuWriteCfg(smpu28cfg, v[7 ..0]);
                smpu29cfg  = smpuWriteCfg(smpu29cfg, v[15..8]);
                smpu30cfg  = smpuWriteCfg(smpu30cfg, v[23..16]);
                smpu31cfg  = smpuWriteCfg(smpu31cfg, v[31..24]);
              },
         8 => { smpu32cfg  = smpuWriteCfg(smpu32cfg, v[7 ..0]);
                smpu33cfg  = smpuWriteCfg(smpu33cfg, v[15..8]);
                smpu34cfg  = smpuWriteCfg(smpu34cfg, v[23..16]);
                smpu35cfg  = smpuWriteCfg(smpu35cfg, v[31..24]);
              },
         9 => { smpu36cfg  = smpuWriteCfg(smpu36cfg, v[7 ..0]);
                smpu37cfg  = smpuWriteCfg(smpu37cfg, v[15..8]);
                smpu38cfg  = smpuWriteCfg(smpu38cfg, v[23..16]);
                smpu39cfg  = smpuWriteCfg(smpu39cfg, v[31..24]);
              },
         10 => { smpu40cfg = smpuWriteCfg(smpu40cfg, v[7 ..0]);
                 smpu41cfg = smpuWriteCfg(smpu41cfg, v[15..8]);
                 smpu42cfg = smpuWriteCfg(smpu42cfg, v[23..16]);
                 smpu43cfg = smpuWriteCfg(smpu43cfg, v[31..24]);
              },
         11 => { smpu44cfg = smpuWriteCfg(smpu44cfg, v[7 ..0]);
                 smpu45cfg = smpuWriteCfg(smpu45cfg, v[15..8]);
                 smpu46cfg = smpuWriteCfg(smpu46cfg, v[23..16]);
                 smpu47cfg = smpuWriteCfg(smpu47cfg, v[31..24]);
              },
         12 => { smpu48cfg = smpuWriteCfg(smpu48cfg, v[7 ..0]);
                 smpu49cfg = smpuWriteCfg(smpu49cfg, v[15..8]);
                 smpu50cfg = smpuWriteCfg(smpu50cfg, v[23..16]);
                 smpu51cfg = smpuWriteCfg(smpu51cfg, v[31..24]);
              },
         13 => { smpu52cfg = smpuWriteCfg(smpu52cfg, v[7 ..0]);
                 smpu53cfg = smpuWriteCfg(smpu53cfg, v[15..8]);
                 smpu54cfg = smpuWriteCfg(smpu54cfg, v[23..16]);
                 smpu55cfg = smpuWriteCfg(smpu55cfg, v[31..24]);
              },
         14 => { smpu56cfg = smpuWriteCfg(smpu56cfg, v[7 ..0]);
                 smpu57cfg = smpuWriteCfg(smpu57cfg, v[15..8]);
                 smpu58cfg = smpuWriteCfg(smpu58cfg, v[23..16]);
                 smpu59cfg = smpuWriteCfg(smpu59cfg, v[31..24]);
              },
         15 => { smpu60cfg = smpuWriteCfg(smpu60cfg, v[7 ..0]);
                 smpu61cfg = smpuWriteCfg(smpu61cfg, v[15..8]);
                 smpu62cfg = smpuWriteCfg(smpu62cfg, v[23..16]);
                 smpu63cfg = smpuWriteCfg(smpu63cfg, v[31..24]);
              }
       }
  else if sizeof(xlen) == 64
  then match n {
         0 => { smpu0cfg  = smpuWriteCfg(smpu0cfg,  v[7 ..0]);
                smpu1cfg  = smpuWriteCfg(smpu1cfg,  v[15..8]);
                smpu2cfg  = smpuWriteCfg(smpu2cfg,  v[23..16]);
                smpu3cfg  = smpuWriteCfg(smpu3cfg,  v[31..24]);
                smpu4cfg  = smpuWriteCfg(smpu4cfg,  v[39..32]);
                smpu5cfg  = smpuWriteCfg(smpu5cfg,  v[47..40]);
                smpu6cfg  = smpuWriteCfg(smpu6cfg,  v[55..48]);
                smpu7cfg  = smpuWriteCfg(smpu7cfg,  v[63..56])
              },
         2 => { smpu8cfg  = smpuWriteCfg(smpu8cfg,  v[7 ..0]);
                smpu9cfg  = smpuWriteCfg(smpu9cfg,  v[15..8]);
                smpu10cfg = smpuWriteCfg(smpu10cfg, v[23..16]);
                smpu11cfg = smpuWriteCfg(smpu11cfg, v[31..24]);
                smpu12cfg = smpuWriteCfg(smpu12cfg, v[39..32]);
                smpu13cfg = smpuWriteCfg(smpu13cfg, v[47..40]);
                smpu14cfg = smpuWriteCfg(smpu14cfg, v[55..48]);
                smpu15cfg = smpuWriteCfg(smpu15cfg, v[63..56])
              },
         4 => { smpu16cfg = smpuWriteCfg(smpu16cfg, v[7 ..0]);
                smpu17cfg = smpuWriteCfg(smpu17cfg, v[15..8]);
                smpu18cfg = smpuWriteCfg(smpu18cfg, v[23..16]);
                smpu19cfg = smpuWriteCfg(smpu19cfg, v[31..24]);
                smpu20cfg = smpuWriteCfg(smpu20cfg, v[39..32]);
                smpu21cfg = smpuWriteCfg(smpu21cfg, v[47..40]);
                smpu22cfg = smpuWriteCfg(smpu22cfg, v[55..48]);
                smpu23cfg = smpuWriteCfg(smpu23cfg, v[63..56])
              },
         6 => { smpu24cfg = smpuWriteCfg(smpu24cfg, v[7 ..0]);
                smpu25cfg = smpuWriteCfg(smpu25cfg, v[15..8]);
                smpu26cfg = smpuWriteCfg(smpu26cfg, v[23..16]);
                smpu27cfg = smpuWriteCfg(smpu27cfg, v[31..24]);
                smpu28cfg = smpuWriteCfg(smpu28cfg, v[39..32]);
                smpu29cfg = smpuWriteCfg(smpu29cfg, v[47..40]);
                smpu30cfg = smpuWriteCfg(smpu30cfg, v[55..48]);
                smpu31cfg = smpuWriteCfg(smpu31cfg, v[63..56])
              },
         8 => { smpu32cfg = smpuWriteCfg(smpu32cfg, v[7 ..0]);
                smpu33cfg = smpuWriteCfg(smpu33cfg, v[15..8]);
                smpu34cfg = smpuWriteCfg(smpu34cfg, v[23..16]);
                smpu35cfg = smpuWriteCfg(smpu35cfg, v[31..24]);
                smpu36cfg = smpuWriteCfg(smpu36cfg, v[39..32]);
                smpu37cfg = smpuWriteCfg(smpu37cfg, v[47..40]);
                smpu38cfg = smpuWriteCfg(smpu38cfg, v[55..48]);
                smpu39cfg = smpuWriteCfg(smpu39cfg, v[63..56])
              },
         10 => { smpu40cfg = smpuWriteCfg(smpu40cfg, v[7 ..0]);
                smpu41cfg  = smpuWriteCfg(smpu41cfg, v[15..8]);
                smpu42cfg  = smpuWriteCfg(smpu42cfg, v[23..16]);
                smpu43cfg  = smpuWriteCfg(smpu43cfg, v[31..24]);
                smpu44cfg  = smpuWriteCfg(smpu44cfg, v[39..32]);
                smpu45cfg  = smpuWriteCfg(smpu45cfg, v[47..40]);
                smpu46cfg  = smpuWriteCfg(smpu46cfg, v[55..48]);
                smpu47cfg  = smpuWriteCfg(smpu47cfg, v[63..56])
              },
         12 => { smpu48cfg = smpuWriteCfg(smpu48cfg, v[7 ..0]);
                 smpu49cfg = smpuWriteCfg(smpu49cfg, v[15..8]);
                 smpu50cfg = smpuWriteCfg(smpu50cfg, v[23..16]);
                 smpu51cfg = smpuWriteCfg(smpu51cfg, v[31..24]);
                 smpu52cfg = smpuWriteCfg(smpu52cfg, v[39..32]);
                 smpu53cfg = smpuWriteCfg(smpu53cfg, v[47..40]);
                 smpu54cfg = smpuWriteCfg(smpu54cfg, v[55..48]);
                 smpu55cfg = smpuWriteCfg(smpu55cfg, v[63..56])
              },
         14 => { smpu56cfg = smpuWriteCfg(smpu56cfg, v[7 ..0]);
                 smpu57cfg = smpuWriteCfg(smpu57cfg, v[15..8]);
                 smpu58cfg = smpuWriteCfg(smpu58cfg, v[23..16]);
                 smpu59cfg = smpuWriteCfg(smpu59cfg, v[31..24]);
                 smpu60cfg = smpuWriteCfg(smpu60cfg, v[39..32]);
                 smpu61cfg = smpuWriteCfg(smpu61cfg, v[47..40]);
                 smpu62cfg = smpuWriteCfg(smpu62cfg, v[55..48]);
                 smpu63cfg = smpuWriteCfg(smpu63cfg, v[63..56])
              }
       }
}

function smpuWriteAddr(reg: xlenbits, v: xlenbits) -> xlenbits =
  if   sizeof(xlen) == 32
  then { v }
  else { EXTZ(v[53..0]) }
