/*=======================================================================================*/
/*  RISCV Sail Model                                                                     */
/*                                                                                       */
/*  This Sail RISC-V architecture model, comprising all files and                        */
/*  directories except for the snapshots of the Lem and Sail libraries                   */
/*  in the prover_snapshots directory (which include copies of their                     */
/*  licences), is subject to the BSD two-clause licence below.                           */
/*                                                                                       */
/*  Copyright (c) 2017-2021                                                              */
/*    Prashanth Mundkur                                                                  */
/*    Rishiyur S. Nikhil and Bluespec, Inc.                                              */
/*    Jon French                                                                         */
/*    Brian Campbell                                                                     */
/*    Robert Norton-Wright                                                               */
/*    Alasdair Armstrong                                                                 */
/*    Thomas Bauereiss                                                                   */
/*    Shaked Flur                                                                        */
/*    Christopher Pulte                                                                  */
/*    Peter Sewell                                                                       */
/*    Alexander Richardson                                                               */
/*    Hesham Almatary                                                                    */
/*    Jessica Clarke                                                                     */
/*    Microsoft, for contributions by Robert Norton-Wright and Nathaniel Wesley Filardo  */
/*    Peter Rugg                                                                         */
/*    Aril Computer Corp., for contributions by Scott Johnson                            */
/*                                                                                       */
/*  All rights reserved.                                                                 */
/*                                                                                       */
/*  This software was developed by the above within the Rigorous                         */
/*  Engineering of Mainstream Systems (REMS) project, partly funded by                   */
/*  EPSRC grant EP/K008528/1, at the Universities of Cambridge and                       */
/*  Edinburgh.                                                                           */
/*                                                                                       */
/*  This software was developed by SRI International and the University of               */
/*  Cambridge Computer Laboratory (Department of Computer Science and                    */
/*  Technology) under DARPA/AFRL contract FA8650-18-C-7809 ("CIFV"), and                 */
/*  under DARPA contract HR0011-18-C-0016 ("ECATS") as part of the DARPA                 */
/*  SSITH research programme.                                                            */
/*                                                                                       */
/*  This project has received funding from the European Research Council                 */
/*  (ERC) under the European Union’s Horizon 2020 research and innovation                */
/*  programme (grant agreement 789108, ELVER).                                           */
/*                                                                                       */
/*                                                                                       */
/*  Redistribution and use in source and binary forms, with or without                   */
/*  modification, are permitted provided that the following conditions                   */
/*  are met:                                                                             */
/*  1. Redistributions of source code must retain the above copyright                    */
/*     notice, this list of conditions and the following disclaimer.                     */
/*  2. Redistributions in binary form must reproduce the above copyright                 */
/*     notice, this list of conditions and the following disclaimer in                   */
/*     the documentation and/or other materials provided with the                        */
/*     distribution.                                                                     */
/*                                                                                       */
/*  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''                   */
/*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED                    */
/*  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A                      */
/*  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR                  */
/*  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,                         */
/*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT                     */
/*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF                     */
/*  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND                  */
/*  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,                   */
/*  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT                   */
/*  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF                   */
/*  SUCH DAMAGE.                                                                         */
/*=======================================================================================*/

/* ****************************************************************** */
/* This file specifies the instructions in the 'Zicsr' extension.     */

/* ****************************************************************** */
union clause ast = CSR  : (bits(12), regidx, regidx, bool, csrop)

mapping encdec_csrop : csrop <-> bits(2) = {
  CSRRW <-> 0b01,
  CSRRS <-> 0b10,
  CSRRC <-> 0b11
}

mapping clause encdec = CSR(csr, rs1, rd, is_imm, op)
  <-> csr @ rs1 @ bool_bits(is_imm) @ encdec_csrop(op) @ rd @ 0b1110011

function readCSR csr : csreg -> xlenbits = {
  let res : xlenbits =
  match (csr, sizeof(xlen)) {
    /* machine mode */
    (0xF11,  _) => EXTZ(mvendorid),
    (0xF12,  _) => marchid,
    (0xF13,  _) => mimpid,
    (0xF14,  _) => mhartid,
    (0x300,  _) => mstatus.bits(),
    (0x301,  _) => misa.bits(),
    (0x302,  _) => medeleg.bits(),
    (0x303,  _) => mideleg.bits(),
    (0x304,  _) => mie.bits(),
    (0x305,  _) => get_mtvec(),
    (0x306,  _) => EXTZ(mcounteren.bits()),
    (0x310, 32) => mstatush.bits(),
    (0x320,  _) => EXTZ(mcountinhibit.bits()),

    (0x340,  _) => mscratch,
    (0x341,  _) => get_xret_target(Machine) & pc_alignment_mask(),
    (0x342,  _) => mcause.bits(),
    (0x343,  _) => mtval,
    (0x344,  _) => mip.bits(),

    (0x3A0,  _) => pmpReadCfgReg(0),           // pmpcfg0
    (0x3A1, 32) => pmpReadCfgReg(1),           // pmpcfg1
    (0x3A2,  _) => pmpReadCfgReg(2),           // pmpcfg2
    (0x3A3, 32) => pmpReadCfgReg(3),           // pmpcfg3

    (0x1A0,  _) => smpuReadCfgReg(0),          // smpucfg0
    (0x1A1, 32) => smpuReadCfgReg(1),          // smpucfg1
    (0x1A2,  _) => smpuReadCfgReg(2),          // smpucfg2
    (0x1A3, 32) => smpuReadCfgReg(3),          // smpucfg3
    (0x1A4,  _) => smpuReadCfgReg(4),          // smpucfg4
    (0x1A5, 32) => smpuReadCfgReg(5),          // smpucfg5
    (0x1A6,  _) => smpuReadCfgReg(6),          // smpucfg6
    (0x1A7, 32) => smpuReadCfgReg(7),          // smpucfg7
    (0x1A8,  _) => smpuReadCfgReg(8),          // smpucfg8
    (0x1A9, 32) => smpuReadCfgReg(9),          // smpucfg9
    (0x1AA,  _) => smpuReadCfgReg(10),         // smpucfg10
    (0x1AB, 32) => smpuReadCfgReg(11),         // smpucfg11
    (0x1AC,  _) => smpuReadCfgReg(12),         // smpucfg12
    (0x1AD, 32) => smpuReadCfgReg(13),         // smpucfg13
    (0x1AE,  _) => smpuReadCfgReg(14),         // smpucfg14
    (0x1AF, 32) => smpuReadCfgReg(15),         // smpucfg15
    (0x3B0,  _) => pmpaddr0,
    (0x3B1,  _) => pmpaddr1,
    (0x3B2,  _) => pmpaddr2,
    (0x3B3,  _) => pmpaddr3,
    (0x3B4,  _) => pmpaddr4,
    (0x3B5,  _) => pmpaddr5,
    (0x3B6,  _) => pmpaddr6,
    (0x3B7,  _) => pmpaddr7,
    (0x3B8,  _) => pmpaddr8,
    (0x3B9,  _) => pmpaddr9,
    (0x3BA,  _) => pmpaddr10,
    (0x3BB,  _) => pmpaddr11,
    (0x3BC,  _) => pmpaddr12,
    (0x3BD,  _) => pmpaddr13,
    (0x3BE,  _) => pmpaddr14,
    (0x3BF,  _) => pmpaddr15,

    (0x1B0,  _) => smpuaddr0,
    (0x1B1,  _) => smpuaddr1,
    (0x1B2,  _) => smpuaddr2,
    (0x1B3,  _) => smpuaddr3,
    (0x1B4,  _) => smpuaddr4,
    (0x1B5,  _) => smpuaddr5,
    (0x1B6,  _) => smpuaddr6,
    (0x1B7,  _) => smpuaddr7,
    (0x1B8,  _) => smpuaddr8,
    (0x1B9,  _) => smpuaddr9,
    (0x1BA,  _) => smpuaddr10,
    (0x1BB,  _) => smpuaddr11,
    (0x1BC,  _) => smpuaddr12,
    (0x1BD,  _) => smpuaddr13,
    (0x1BE,  _) => smpuaddr14,
    (0x1BF,  _) => smpuaddr15,
    (0x1C0,  _) => smpuaddr16,
    (0x1C1,  _) => smpuaddr17,
    (0x1C2,  _) => smpuaddr18,
    (0x1C3,  _) => smpuaddr19,
    (0x1C4,  _) => smpuaddr20,
    (0x1C5,  _) => smpuaddr21,
    (0x1C6,  _) => smpuaddr22,
    (0x1C7,  _) => smpuaddr23,
    (0x1C8,  _) => smpuaddr24,
    (0x1C9,  _) => smpuaddr25,
    (0x1CA,  _) => smpuaddr26,
    (0x1CB,  _) => smpuaddr27,
    (0x1CC,  _) => smpuaddr28,
    (0x1CD,  _) => smpuaddr29,
    (0x1CE,  _) => smpuaddr30,
    (0x1CF,  _) => smpuaddr31,
    (0x1D0,  _) => smpuaddr32,
    (0x1D1,  _) => smpuaddr33,
    (0x1D2,  _) => smpuaddr34,
    (0x1D3,  _) => smpuaddr35,
    (0x1D4,  _) => smpuaddr36,
    (0x1D5,  _) => smpuaddr37,
    (0x1D6,  _) => smpuaddr38,
    (0x1D7,  _) => smpuaddr39,
    (0x1D8,  _) => smpuaddr40,
    (0x1D9,  _) => smpuaddr41,
    (0x1DA,  _) => smpuaddr42,
    (0x1DB,  _) => smpuaddr43,
    (0x1DC,  _) => smpuaddr44,
    (0x1DD,  _) => smpuaddr45,
    (0x1DE,  _) => smpuaddr46,
    (0x1DF,  _) => smpuaddr47,
    (0x1E0,  _) => smpuaddr48,
    (0x1E1,  _) => smpuaddr49,
    (0x1E2,  _) => smpuaddr50,
    (0x1E3,  _) => smpuaddr51,
    (0x1E4,  _) => smpuaddr52,
    (0x1E5,  _) => smpuaddr53,
    (0x1E6,  _) => smpuaddr54,
    (0x1E7,  _) => smpuaddr55,
    (0x1E8,  _) => smpuaddr56,
    (0x1E9,  _) => smpuaddr57,
    (0x1EA,  _) => smpuaddr58,
    (0x1EB,  _) => smpuaddr59,
    (0x1EC,  _) => smpuaddr60,
    (0x1ED,  _) => smpuaddr61,
    (0x1EE,  _) => smpuaddr62,
    (0x1EF,  _) => smpuaddr63,

    /* machine mode counters */
    (0xB00,  _) => mcycle[(sizeof(xlen) - 1) .. 0],
    (0xB02,  _) => minstret[(sizeof(xlen) - 1) .. 0],
    (0xB80, 32) => mcycle[63 .. 32],
    (0xB82, 32) => minstret[63 .. 32],

    /* trigger/debug */
    (0x7a0,  _) => ~(tselect),  /* this indicates we don't have any trigger support */

    /* supervisor mode */
    (0x100,  _) => lower_mstatus(mstatus).bits(),
    (0x102,  _) => sedeleg.bits(),
    (0x103,  _) => sideleg.bits(),
    (0x104,  _) => lower_mie(mie, mideleg).bits(),
    (0x105,  _) => get_stvec(),
    (0x106,  _) => EXTZ(scounteren.bits()),
    (0x140,  _) => sscratch,
    (0x141,  _) => get_xret_target(Supervisor) & pc_alignment_mask(),
    (0x142,  _) => scause.bits(),
    (0x143,  _) => stval,
    (0x144,  _) => lower_mip(mip, mideleg).bits(),
    (0x180,  _) => satp,

    /* user mode counters */
    (0xC00,  _) => mcycle[(sizeof(xlen) - 1) .. 0],
    (0xC01,  _) => mtime[(sizeof(xlen) - 1) .. 0],
    (0xC02,  _) => minstret[(sizeof(xlen) - 1) .. 0],
    (0xC80, 32) => mcycle[63 .. 32],
    (0xC81, 32) => mtime[63 .. 32],
    (0xC82, 32) => minstret[63 .. 32],

    /* user mode: Zkr */
    (0x015,  _) => read_seed_csr(),

    _           => /* check extensions */
                   match ext_read_CSR(csr) {
                     Some(res) => res,
                     None()    => { print_bits("unhandled read to CSR ", csr);
                                    EXTZ(0x0) }
                   }
  };
  if   get_config_print_reg()
  then print_reg("CSR " ^ to_str(csr) ^ " -> " ^ BitStr(res));
  res
}

function writeCSR (csr : csreg, value : xlenbits) -> unit = {
  let res : option(xlenbits) =
  match (csr, sizeof(xlen)) {
    /* machine mode */
    (0x300,  _) => { mstatus = legalize_mstatus(mstatus, value); Some(mstatus.bits()) },
    (0x301,  _) => { misa = legalize_misa(misa, value); Some(misa.bits()) },
    (0x302,  _) => { medeleg = legalize_medeleg(medeleg, value); Some(medeleg.bits()) },
    (0x303,  _) => { mideleg = legalize_mideleg(mideleg, value); Some(mideleg.bits()) },
    (0x304,  _) => { mie = legalize_mie(mie, value); Some(mie.bits()) },
    (0x305,  _) => { Some(set_mtvec(value)) },
    (0x306,  _) => { mcounteren = legalize_mcounteren(mcounteren, value); Some(EXTZ(mcounteren.bits())) },
    (0x310, 32) => { Some(mstatush.bits()) }, // ignore writes for now
    (0x320,  _) => { mcountinhibit = legalize_mcountinhibit(mcountinhibit, value); Some(EXTZ(mcountinhibit.bits())) },
    (0x340,  _) => { mscratch = value; Some(mscratch) },
    (0x341,  _) => { Some(set_xret_target(Machine, value)) },
    (0x342,  _) => { mcause->bits() = value; Some(mcause.bits()) },
    (0x343,  _) => { mtval = value; Some(mtval) },
    (0x344,  _) => { mip = legalize_mip(mip, value); Some(mip.bits()) },

    // Note: Some(value) returned below is not the legalized value due to locked entries
    (0x3A0,  _) => { pmpWriteCfgReg(0, value); Some(pmpReadCfgReg(0)) },  // pmpcfg0
    (0x3A1, 32) => { pmpWriteCfgReg(1, value); Some(pmpReadCfgReg(1)) },  // pmpcfg1
    (0x3A2,  _) => { pmpWriteCfgReg(2, value); Some(pmpReadCfgReg(2)) },  // pmpcfg2
    (0x3A3, 32) => { pmpWriteCfgReg(3, value); Some(pmpReadCfgReg(3)) },  // pmpcfg3

    (0x3B0,  _) => { pmpaddr0  = pmpWriteAddr(pmpLocked(pmp0cfg),  pmpTORLocked(pmp1cfg),  pmpaddr0,  value); Some(pmpaddr0) },
    (0x3B1,  _) => { pmpaddr1  = pmpWriteAddr(pmpLocked(pmp1cfg),  pmpTORLocked(pmp2cfg),  pmpaddr1,  value); Some(pmpaddr1) },
    (0x3B2,  _) => { pmpaddr2  = pmpWriteAddr(pmpLocked(pmp2cfg),  pmpTORLocked(pmp3cfg),  pmpaddr2,  value); Some(pmpaddr2) },
    (0x3B3,  _) => { pmpaddr3  = pmpWriteAddr(pmpLocked(pmp3cfg),  pmpTORLocked(pmp4cfg),  pmpaddr3,  value); Some(pmpaddr3) },
    (0x3B4,  _) => { pmpaddr4  = pmpWriteAddr(pmpLocked(pmp4cfg),  pmpTORLocked(pmp5cfg),  pmpaddr4,  value); Some(pmpaddr4) },
    (0x3B5,  _) => { pmpaddr5  = pmpWriteAddr(pmpLocked(pmp5cfg),  pmpTORLocked(pmp6cfg),  pmpaddr5,  value); Some(pmpaddr5) },
    (0x3B6,  _) => { pmpaddr6  = pmpWriteAddr(pmpLocked(pmp6cfg),  pmpTORLocked(pmp7cfg),  pmpaddr6,  value); Some(pmpaddr6) },
    (0x3B7,  _) => { pmpaddr7  = pmpWriteAddr(pmpLocked(pmp7cfg),  pmpTORLocked(pmp8cfg),  pmpaddr7,  value); Some(pmpaddr7) },
    (0x3B8,  _) => { pmpaddr8  = pmpWriteAddr(pmpLocked(pmp8cfg),  pmpTORLocked(pmp9cfg),  pmpaddr8,  value); Some(pmpaddr8) },
    (0x3B9,  _) => { pmpaddr9  = pmpWriteAddr(pmpLocked(pmp9cfg),  pmpTORLocked(pmp10cfg), pmpaddr9,  value); Some(pmpaddr9) },
    (0x3BA,  _) => { pmpaddr10 = pmpWriteAddr(pmpLocked(pmp10cfg), pmpTORLocked(pmp11cfg), pmpaddr10, value); Some(pmpaddr10) },
    (0x3BB,  _) => { pmpaddr11 = pmpWriteAddr(pmpLocked(pmp11cfg), pmpTORLocked(pmp12cfg), pmpaddr11, value); Some(pmpaddr11) },
    (0x3BC,  _) => { pmpaddr12 = pmpWriteAddr(pmpLocked(pmp12cfg), pmpTORLocked(pmp13cfg), pmpaddr12, value); Some(pmpaddr12) },
    (0x3BD,  _) => { pmpaddr13 = pmpWriteAddr(pmpLocked(pmp13cfg), pmpTORLocked(pmp14cfg), pmpaddr13, value); Some(pmpaddr13) },
    (0x3BE,  _) => { pmpaddr14 = pmpWriteAddr(pmpLocked(pmp14cfg), pmpTORLocked(pmp15cfg), pmpaddr14, value); Some(pmpaddr14) },
    (0x3BF,  _) => { pmpaddr15 = pmpWriteAddr(pmpLocked(pmp15cfg), false,                  pmpaddr15, value); Some(pmpaddr15) },

    (0x1A0,  _) => { smpuWriteCfgReg(0, value); Some(smpuReadCfgReg(0)) },  // smpucfg0
    (0x1A1, 32) => { smpuWriteCfgReg(1, value); Some(smpuReadCfgReg(1)) },  // smpucfg1
    (0x1A2,  _) => { smpuWriteCfgReg(2, value); Some(smpuReadCfgReg(2)) },  // smpucfg2
    (0x1A3, 32) => { smpuWriteCfgReg(3, value); Some(smpuReadCfgReg(3)) },  // smpucfg3
    (0x1A4,  _) => { smpuWriteCfgReg(4, value); Some(smpuReadCfgReg(4)) },  // smpucfg4
    (0x1A5, 32) => { smpuWriteCfgReg(5, value); Some(smpuReadCfgReg(5)) },  // smpucfg5
    (0x1A6,  _) => { smpuWriteCfgReg(6, value); Some(smpuReadCfgReg(6)) },  // smpucfg6
    (0x1A7, 32) => { smpuWriteCfgReg(7, value); Some(smpuReadCfgReg(7)) },  // smpucfg7
    (0x1A8,  _) => { smpuWriteCfgReg(8, value); Some(smpuReadCfgReg(8)) },  // smpucfg8
    (0x1A9, 32) => { smpuWriteCfgReg(9, value); Some(smpuReadCfgReg(9)) },  // smpucfg9
    (0x1AA,  _) => { smpuWriteCfgReg(10, value); Some(smpuReadCfgReg(10)) },  // smpucfg10
    (0x1AB, 32) => { smpuWriteCfgReg(11, value); Some(smpuReadCfgReg(11)) },  // smpucfg11
    (0x1AC,  _) => { smpuWriteCfgReg(12, value); Some(smpuReadCfgReg(12)) },  // smpucfg12
    (0x1AD, 32) => { smpuWriteCfgReg(13, value); Some(smpuReadCfgReg(13)) },  // smpucfg13
    (0x1AE,  _) => { smpuWriteCfgReg(14, value); Some(smpuReadCfgReg(14)) },  // smpucfg14
    (0x1AF, 32) => { smpuWriteCfgReg(15, value); Some(smpuReadCfgReg(15)) },  // smpucfg15

    (0x1B0,  _) => { smpuaddr0  = smpuWriteAddr(smpuaddr0,  value); Some(smpuaddr0) },
    (0x1B1,  _) => { smpuaddr1  = smpuWriteAddr(smpuaddr1,  value); Some(smpuaddr1) },
    (0x1B2,  _) => { smpuaddr2  = smpuWriteAddr(smpuaddr2,  value); Some(smpuaddr2) },
    (0x1B3,  _) => { smpuaddr3  = smpuWriteAddr(smpuaddr3,  value); Some(smpuaddr3) },
    (0x1B4,  _) => { smpuaddr4  = smpuWriteAddr(smpuaddr4,  value); Some(smpuaddr4) },
    (0x1B5,  _) => { smpuaddr5  = smpuWriteAddr(smpuaddr5,  value); Some(smpuaddr5) },
    (0x1B6,  _) => { smpuaddr6  = smpuWriteAddr(smpuaddr6,  value); Some(smpuaddr6) },
    (0x1B7,  _) => { smpuaddr7  = smpuWriteAddr(smpuaddr7,  value); Some(smpuaddr7) },
    (0x1B8,  _) => { smpuaddr8  = smpuWriteAddr(smpuaddr8,  value); Some(smpuaddr8) },
    (0x1B9,  _) => { smpuaddr9  = smpuWriteAddr(smpuaddr9,  value); Some(smpuaddr9) },
    (0x1BA,  _) => { smpuaddr10 = smpuWriteAddr(smpuaddr10, value); Some(smpuaddr10) },
    (0x1BB,  _) => { smpuaddr11 = smpuWriteAddr(smpuaddr11, value); Some(smpuaddr11) },
    (0x1BC,  _) => { smpuaddr12 = smpuWriteAddr(smpuaddr12, value); Some(smpuaddr12) },
    (0x1BD,  _) => { smpuaddr13 = smpuWriteAddr(smpuaddr13, value); Some(smpuaddr13) },
    (0x1BE,  _) => { smpuaddr14 = smpuWriteAddr(smpuaddr14, value); Some(smpuaddr14) },
    (0x1BF,  _) => { smpuaddr15 = smpuWriteAddr(smpuaddr15, value); Some(smpuaddr15) },
    (0x1C0,  _) => { smpuaddr16 = smpuWriteAddr(smpuaddr16, value); Some(smpuaddr16) },
    (0x1C1,  _) => { smpuaddr17 = smpuWriteAddr(smpuaddr17, value); Some(smpuaddr17) },
    (0x1C2,  _) => { smpuaddr18 = smpuWriteAddr(smpuaddr18, value); Some(smpuaddr18) },
    (0x1C3,  _) => { smpuaddr19 = smpuWriteAddr(smpuaddr19, value); Some(smpuaddr19) },
    (0x1C4,  _) => { smpuaddr20 = smpuWriteAddr(smpuaddr20, value); Some(smpuaddr20) },
    (0x1C5,  _) => { smpuaddr21 = smpuWriteAddr(smpuaddr21, value); Some(smpuaddr21) },
    (0x1C6,  _) => { smpuaddr22 = smpuWriteAddr(smpuaddr22, value); Some(smpuaddr22) },
    (0x1C7,  _) => { smpuaddr23 = smpuWriteAddr(smpuaddr23, value); Some(smpuaddr23) },
    (0x1C8,  _) => { smpuaddr24 = smpuWriteAddr(smpuaddr24, value); Some(smpuaddr24) },
    (0x1C9,  _) => { smpuaddr25 = smpuWriteAddr(smpuaddr25, value); Some(smpuaddr25) },
    (0x1CA,  _) => { smpuaddr26 = smpuWriteAddr(smpuaddr26, value); Some(smpuaddr26) },
    (0x1CB,  _) => { smpuaddr27 = smpuWriteAddr(smpuaddr27, value); Some(smpuaddr27) },
    (0x1CC,  _) => { smpuaddr28 = smpuWriteAddr(smpuaddr28, value); Some(smpuaddr28) },
    (0x1CD,  _) => { smpuaddr29 = smpuWriteAddr(smpuaddr29, value); Some(smpuaddr29) },
    (0x1CE,  _) => { smpuaddr30 = smpuWriteAddr(smpuaddr30, value); Some(smpuaddr30) },
    (0x1CF,  _) => { smpuaddr31 = smpuWriteAddr(smpuaddr31, value); Some(smpuaddr31) },
    (0x1D0,  _) => { smpuaddr32 = smpuWriteAddr(smpuaddr32, value); Some(smpuaddr32) },
    (0x1D1,  _) => { smpuaddr33 = smpuWriteAddr(smpuaddr33, value); Some(smpuaddr33) },
    (0x1D2,  _) => { smpuaddr34 = smpuWriteAddr(smpuaddr34, value); Some(smpuaddr34) },
    (0x1D3,  _) => { smpuaddr35 = smpuWriteAddr(smpuaddr35, value); Some(smpuaddr35) },
    (0x1D4,  _) => { smpuaddr36 = smpuWriteAddr(smpuaddr36, value); Some(smpuaddr36) },
    (0x1D5,  _) => { smpuaddr37 = smpuWriteAddr(smpuaddr37, value); Some(smpuaddr37) },
    (0x1D6,  _) => { smpuaddr38 = smpuWriteAddr(smpuaddr38, value); Some(smpuaddr38) },
    (0x1D7,  _) => { smpuaddr39 = smpuWriteAddr(smpuaddr39, value); Some(smpuaddr39) },
    (0x1D8,  _) => { smpuaddr40 = smpuWriteAddr(smpuaddr40, value); Some(smpuaddr40) },
    (0x1D9,  _) => { smpuaddr41 = smpuWriteAddr(smpuaddr41, value); Some(smpuaddr41) },
    (0x1DA,  _) => { smpuaddr42 = smpuWriteAddr(smpuaddr42, value); Some(smpuaddr42) },
    (0x1DB,  _) => { smpuaddr43 = smpuWriteAddr(smpuaddr43, value); Some(smpuaddr43) },
    (0x1DC,  _) => { smpuaddr44 = smpuWriteAddr(smpuaddr44, value); Some(smpuaddr44) },
    (0x1DD,  _) => { smpuaddr45 = smpuWriteAddr(smpuaddr45, value); Some(smpuaddr45) },
    (0x1DE,  _) => { smpuaddr46 = smpuWriteAddr(smpuaddr46, value); Some(smpuaddr46) },
    (0x1DF,  _) => { smpuaddr47 = smpuWriteAddr(smpuaddr47, value); Some(smpuaddr47) },
    (0x1E0,  _) => { smpuaddr48 = smpuWriteAddr(smpuaddr48, value); Some(smpuaddr48) },
    (0x1E1,  _) => { smpuaddr49 = smpuWriteAddr(smpuaddr49, value); Some(smpuaddr49) },
    (0x1E2,  _) => { smpuaddr50 = smpuWriteAddr(smpuaddr50, value); Some(smpuaddr50) },
    (0x1E3,  _) => { smpuaddr51 = smpuWriteAddr(smpuaddr51, value); Some(smpuaddr51) },
    (0x1E4,  _) => { smpuaddr52 = smpuWriteAddr(smpuaddr52, value); Some(smpuaddr52) },
    (0x1E5,  _) => { smpuaddr53 = smpuWriteAddr(smpuaddr53, value); Some(smpuaddr53) },
    (0x1E6,  _) => { smpuaddr54 = smpuWriteAddr(smpuaddr54, value); Some(smpuaddr54) },
    (0x1E7,  _) => { smpuaddr55 = smpuWriteAddr(smpuaddr55, value); Some(smpuaddr55) },
    (0x1E8,  _) => { smpuaddr56 = smpuWriteAddr(smpuaddr56, value); Some(smpuaddr56) },
    (0x1E9,  _) => { smpuaddr57 = smpuWriteAddr(smpuaddr57, value); Some(smpuaddr57) },
    (0x1EA,  _) => { smpuaddr58 = smpuWriteAddr(smpuaddr58, value); Some(smpuaddr58) },
    (0x1EB,  _) => { smpuaddr59 = smpuWriteAddr(smpuaddr59, value); Some(smpuaddr59) },
    (0x1EC,  _) => { smpuaddr60 = smpuWriteAddr(smpuaddr60, value); Some(smpuaddr60) },
    (0x1ED,  _) => { smpuaddr61 = smpuWriteAddr(smpuaddr61, value); Some(smpuaddr61) },
    (0x1EE,  _) => { smpuaddr62 = smpuWriteAddr(smpuaddr62, value); Some(smpuaddr62) },
    (0x1EF,  _) => { smpuaddr63 = smpuWriteAddr(smpuaddr63, value); Some(smpuaddr63) },

    /* machine mode counters */
    (0xB00,  _) => { mcycle[(sizeof(xlen) - 1) .. 0] = value; Some(value) },
    (0xB02,  _) => { minstret[(sizeof(xlen) - 1) .. 0] = value; minstret_written = true; Some(value) },
    (0xB80, 32) => { mcycle[63 .. 32] = value; Some(value) },
    (0xB82, 32) => { minstret[63 .. 32] = value; minstret_written = true; Some(value) },

    /* trigger/debug */
    (0x7a0,  _) => { tselect = value; Some(tselect) },

    /* supervisor mode */
    (0x100,  _) => { mstatus = legalize_sstatus(mstatus, value); Some(mstatus.bits()) },
    (0x102,  _) => { sedeleg = legalize_sedeleg(sedeleg, value); Some(sedeleg.bits()) },
    (0x103,  _) => { sideleg->bits() = value; Some(sideleg.bits()) }, /* TODO: does this need legalization? */
    (0x104,  _) => { mie = legalize_sie(mie, mideleg, value); Some(mie.bits()) },
    (0x105,  _) => { Some(set_stvec(value)) },
    (0x106,  _) => { scounteren = legalize_scounteren(scounteren, value); Some(EXTZ(scounteren.bits())) },
    (0x140,  _) => { sscratch = value; Some(sscratch) },
    (0x141,  _) => { Some(set_xret_target(Supervisor, value)) },
    (0x142,  _) => { scause->bits() = value; Some(scause.bits()) },
    (0x143,  _) => { stval = value; Some(stval) },
    (0x144,  _) => { mip = legalize_sip(mip, mideleg, value); Some(mip.bits()) },
    (0x180,  _) => { satp = legalize_satp(cur_Architecture(), satp, value); Some(satp) },

    /* user mode: seed (entropy source). writes are ignored */
    (0x015,  _) => write_seed_csr(),

    _           => ext_write_CSR(csr, value)
  };
  match res {
    Some(v) => if   get_config_print_reg()
               then print_reg("CSR " ^ to_str(csr) ^ " <- " ^ BitStr(v) ^ " (input: " ^ BitStr(value) ^ ")"),
    None()  => print_bits("unhandled write to CSR ", csr)
  }
}

function clause execute CSR(csr, rs1, rd, is_imm, op) = {
  let rs1_val : xlenbits = if is_imm then EXTZ(rs1) else X(rs1);
  let isWrite : bool = match op {
    CSRRW  => true,
    _      => if is_imm then unsigned(rs1_val) != 0 else unsigned(rs1) != 0
  };
  if ~ (check_CSR(csr, cur_privilege, isWrite))
  then { handle_illegal(); RETIRE_FAIL }
  else if ~ (ext_check_CSR(csr, cur_privilege, isWrite))
  then { ext_check_CSR_fail(); RETIRE_FAIL }
  else {
    let csr_val = readCSR(csr); /* could have side-effects, so technically shouldn't perform for CSRW[I] with rd == 0 */
    if isWrite then {
      let new_val : xlenbits = match op {
        CSRRW => rs1_val,
        CSRRS => csr_val | rs1_val,
        CSRRC => csr_val & ~(rs1_val)
      };
      writeCSR(csr, new_val)
    };
    X(rd) = csr_val;
    RETIRE_SUCCESS
  }
}

mapping maybe_i : bool <-> string = {
  true  <-> "i",
  false <-> ""
}

mapping csr_mnemonic : csrop <-> string = {
  CSRRW <-> "csrrw",
  CSRRS <-> "csrrs",
  CSRRC <-> "csrrc"
}

mapping clause assembly = CSR(csr, rs1, rd, true, op)
  <-> csr_mnemonic(op) ^ "i" ^ spc() ^ reg_name(rd)  ^ sep() ^ csr_name_map(csr) ^ sep() ^ hex_bits_5(rs1)
mapping clause assembly = CSR(csr, rs1, rd, false, op)
  <-> csr_mnemonic(op) ^ spc() ^ reg_name(rd) ^ sep() ^ csr_name_map(csr) ^ sep() ^ reg_name(rs1)
