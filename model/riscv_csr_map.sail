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

/* Mapping of csr addresses to their names. */

val csr_name_map : csreg <-> string

scattered mapping csr_name_map

/* user trap setup */
mapping clause csr_name_map = 0x000  <-> "ustatus"
mapping clause csr_name_map = 0x004  <-> "uie"
mapping clause csr_name_map = 0x005  <-> "utvec"
/* user trap handling */
mapping clause csr_name_map = 0x040  <-> "uscratch"
mapping clause csr_name_map = 0x041  <-> "uepc"
mapping clause csr_name_map = 0x042  <-> "ucause"
mapping clause csr_name_map = 0x043  <-> "utval"
mapping clause csr_name_map = 0x044  <-> "uip"
/* user floating-point context */
mapping clause csr_name_map = 0x001  <-> "fflags"
mapping clause csr_name_map = 0x002  <-> "frm"
mapping clause csr_name_map = 0x003  <-> "fcsr"
/* user entropy source */
mapping clause csr_name_map = 0x015  <-> "seed"
/* counter/timers */
mapping clause csr_name_map = 0xC00  <-> "cycle"
mapping clause csr_name_map = 0xC01  <-> "time"
mapping clause csr_name_map = 0xC02  <-> "instret"
mapping clause csr_name_map = 0xC80  <-> "cycleh"
mapping clause csr_name_map = 0xC81  <-> "timeh"
mapping clause csr_name_map = 0xC82  <-> "instreth"
/* TODO: other hpm counters */
/* supervisor trap setup */
mapping clause csr_name_map = 0x100  <-> "sstatus"
mapping clause csr_name_map = 0x102  <-> "sedeleg"
mapping clause csr_name_map = 0x103  <-> "sideleg"
mapping clause csr_name_map = 0x104  <-> "sie"
mapping clause csr_name_map = 0x105  <-> "stvec"
mapping clause csr_name_map = 0x106  <-> "scounteren"
/* supervisor trap handling */
mapping clause csr_name_map = 0x140  <-> "sscratch"
mapping clause csr_name_map = 0x141  <-> "sepc"
mapping clause csr_name_map = 0x142  <-> "scause"
mapping clause csr_name_map = 0x143  <-> "stval"
mapping clause csr_name_map = 0x144  <-> "sip"
/* supervisor protection and translation */
mapping clause csr_name_map = 0x180  <-> "satp"
/* machine information registers */
mapping clause csr_name_map = 0xF11  <-> "mvendorid"
mapping clause csr_name_map = 0xF12  <-> "marchid"
mapping clause csr_name_map = 0xF13  <-> "mimpid"
mapping clause csr_name_map = 0xF14  <-> "mhartid"
/* machine trap setup */
mapping clause csr_name_map = 0x300  <-> "mstatus"
mapping clause csr_name_map = 0x301  <-> "misa"
mapping clause csr_name_map = 0x302  <-> "medeleg"
mapping clause csr_name_map = 0x303  <-> "mideleg"
mapping clause csr_name_map = 0x304  <-> "mie"
mapping clause csr_name_map = 0x305  <-> "mtvec"
mapping clause csr_name_map = 0x306  <-> "mcounteren"
mapping clause csr_name_map = 0x320  <-> "mcountinhibit"
/* machine trap handling */
mapping clause csr_name_map = 0x340  <-> "mscratch"
mapping clause csr_name_map = 0x341  <-> "mepc"
mapping clause csr_name_map = 0x342  <-> "mcause"
mapping clause csr_name_map = 0x343  <-> "mtval"
mapping clause csr_name_map = 0x344  <-> "mip"
/* machine protection and translation */
mapping clause csr_name_map = 0x3A0  <-> "pmpcfg0"
mapping clause csr_name_map = 0x3A1  <-> "pmpcfg1"
mapping clause csr_name_map = 0x3A2  <-> "pmpcfg2"
mapping clause csr_name_map = 0x3A3  <-> "pmpcfg3"
mapping clause csr_name_map = 0x3B0  <-> "pmpaddr0"
mapping clause csr_name_map = 0x3B1  <-> "pmpaddr1"
mapping clause csr_name_map = 0x3B2  <-> "pmpaddr2"
mapping clause csr_name_map = 0x3B3  <-> "pmpaddr3"
mapping clause csr_name_map = 0x3B4  <-> "pmpaddr4"
mapping clause csr_name_map = 0x3B5  <-> "pmpaddr5"
mapping clause csr_name_map = 0x3B6  <-> "pmpaddr6"
mapping clause csr_name_map = 0x3B7  <-> "pmpaddr7"
mapping clause csr_name_map = 0x3B8  <-> "pmpaddr8"
mapping clause csr_name_map = 0x3B9  <-> "pmpaddr9"
mapping clause csr_name_map = 0x3BA  <-> "pmpaddr10"
mapping clause csr_name_map = 0x3BB  <-> "pmpaddr11"
mapping clause csr_name_map = 0x3BC  <-> "pmpaddr12"
mapping clause csr_name_map = 0x3BD  <-> "pmpaddr13"
mapping clause csr_name_map = 0x3BE  <-> "pmpaddr14"
mapping clause csr_name_map = 0x3BF  <-> "pmpaddr15"
/* S-mode Memory Protection Unit */
mapping clause csr_name_map = 0x1A0  <-> "smpucfg0"
mapping clause csr_name_map = 0x1A1  <-> "smpucfg1"
mapping clause csr_name_map = 0x1A2  <-> "smpucfg2"
mapping clause csr_name_map = 0x1A3  <-> "smpucfg3"
mapping clause csr_name_map = 0x1A4  <-> "smpucfg4"
mapping clause csr_name_map = 0x1A5  <-> "smpucfg5"
mapping clause csr_name_map = 0x1A6  <-> "smpucfg6"
mapping clause csr_name_map = 0x1A7  <-> "smpucfg7"
mapping clause csr_name_map = 0x1A8  <-> "smpucfg8"
mapping clause csr_name_map = 0x1A9  <-> "smpucfg9"
mapping clause csr_name_map = 0x1AA  <-> "smpucfg10"
mapping clause csr_name_map = 0x1AB  <-> "smpucfg11"
mapping clause csr_name_map = 0x1AC  <-> "smpucfg12"
mapping clause csr_name_map = 0x1AD  <-> "smpucfg13"
mapping clause csr_name_map = 0x1AE  <-> "smpucfg14"
mapping clause csr_name_map = 0x1AF  <-> "smpucfg15"
mapping clause csr_name_map = 0x1B0  <-> "smpuaddr0"
mapping clause csr_name_map = 0x1B1  <-> "smpuaddr1"
mapping clause csr_name_map = 0x1B2  <-> "smpuaddr2"
mapping clause csr_name_map = 0x1B3  <-> "smpuaddr3"
mapping clause csr_name_map = 0x1B4  <-> "smpuaddr4"
mapping clause csr_name_map = 0x1B5  <-> "smpuaddr5"
mapping clause csr_name_map = 0x1B6  <-> "smpuaddr6"
mapping clause csr_name_map = 0x1B7  <-> "smpuaddr7"
mapping clause csr_name_map = 0x1B8  <-> "smpuaddr8"
mapping clause csr_name_map = 0x1B9  <-> "smpuaddr9"
mapping clause csr_name_map = 0x1BA  <-> "smpuaddr10"
mapping clause csr_name_map = 0x1BB  <-> "smpuaddr11"
mapping clause csr_name_map = 0x1BC  <-> "smpuaddr12"
mapping clause csr_name_map = 0x1BD  <-> "smpuaddr13"
mapping clause csr_name_map = 0x1BE  <-> "smpuaddr14"
mapping clause csr_name_map = 0x1BF  <-> "smpuaddr15"
mapping clause csr_name_map = 0x1C0  <-> "smpuaddr16"
mapping clause csr_name_map = 0x1C1  <-> "smpuaddr17"
mapping clause csr_name_map = 0x1C2  <-> "smpuaddr18"
mapping clause csr_name_map = 0x1C3  <-> "smpuaddr19"
mapping clause csr_name_map = 0x1C4  <-> "smpuaddr20"
mapping clause csr_name_map = 0x1C5  <-> "smpuaddr21"
mapping clause csr_name_map = 0x1C6  <-> "smpuaddr22"
mapping clause csr_name_map = 0x1C7  <-> "smpuaddr23"
mapping clause csr_name_map = 0x1C8  <-> "smpuaddr24"
mapping clause csr_name_map = 0x1C9  <-> "smpuaddr25"
mapping clause csr_name_map = 0x1CA  <-> "smpuaddr26"
mapping clause csr_name_map = 0x1CB  <-> "smpuaddr27"
mapping clause csr_name_map = 0x1CC  <-> "smpuaddr28"
mapping clause csr_name_map = 0x1CD  <-> "smpuaddr29"
mapping clause csr_name_map = 0x1CE  <-> "smpuaddr30"
mapping clause csr_name_map = 0x1CF  <-> "smpuaddr31"
mapping clause csr_name_map = 0x1D0  <-> "smpuaddr32"
mapping clause csr_name_map = 0x1D1  <-> "smpuaddr33"
mapping clause csr_name_map = 0x1D2  <-> "smpuaddr34"
mapping clause csr_name_map = 0x1D3  <-> "smpuaddr35"
mapping clause csr_name_map = 0x1D4  <-> "smpuaddr36"
mapping clause csr_name_map = 0x1D5  <-> "smpuaddr37"
mapping clause csr_name_map = 0x1D6  <-> "smpuaddr38"
mapping clause csr_name_map = 0x1D7  <-> "smpuaddr39"
mapping clause csr_name_map = 0x1D8  <-> "smpuaddr40"
mapping clause csr_name_map = 0x1D9  <-> "smpuaddr41"
mapping clause csr_name_map = 0x1DA  <-> "smpuaddr42"
mapping clause csr_name_map = 0x1DB  <-> "smpuaddr43"
mapping clause csr_name_map = 0x1DC  <-> "smpuaddr44"
mapping clause csr_name_map = 0x1DD  <-> "smpuaddr45"
mapping clause csr_name_map = 0x1DE  <-> "smpuaddr46"
mapping clause csr_name_map = 0x1DF  <-> "smpuaddr47"
mapping clause csr_name_map = 0x1E0  <-> "smpuaddr48"
mapping clause csr_name_map = 0x1E1  <-> "smpuaddr49"
mapping clause csr_name_map = 0x1E2  <-> "smpuaddr50"
mapping clause csr_name_map = 0x1E3  <-> "smpuaddr51"
mapping clause csr_name_map = 0x1E4  <-> "smpuaddr52"
mapping clause csr_name_map = 0x1E5  <-> "smpuaddr53"
mapping clause csr_name_map = 0x1E6  <-> "smpuaddr54"
mapping clause csr_name_map = 0x1E7  <-> "smpuaddr55"
mapping clause csr_name_map = 0x1E8  <-> "smpuaddr56"
mapping clause csr_name_map = 0x1E9  <-> "smpuaddr57"
mapping clause csr_name_map = 0x1EA  <-> "smpuaddr58"
mapping clause csr_name_map = 0x1EB  <-> "smpuaddr59"
mapping clause csr_name_map = 0x1EC  <-> "smpuaddr60"
mapping clause csr_name_map = 0x1ED  <-> "smpuaddr61"
mapping clause csr_name_map = 0x1EE  <-> "smpuaddr62"
mapping clause csr_name_map = 0x1EF  <-> "smpuaddr63"
/* machine counters/timers */
mapping clause csr_name_map = 0xB00  <-> "mcycle"
mapping clause csr_name_map = 0xB02  <-> "minstret"
mapping clause csr_name_map = 0xB80  <-> "mcycleh"
mapping clause csr_name_map = 0xB82  <-> "minstreth"
/* TODO: other hpm counters and events */
/* trigger/debug */
mapping clause csr_name_map = 0x7a0  <-> "tselect"
mapping clause csr_name_map = 0x7a1  <-> "tdata1"
mapping clause csr_name_map = 0x7a2  <-> "tdata2"
mapping clause csr_name_map = 0x7a3  <-> "tdata3"

val csr_name : csreg -> string
overload to_str = {csr_name}

/* Extensions may want to add additional CSR registers to the CSR address map.
 * These scattered functions support access to such registers.
 *
 * The default implementation provides access to the CSRs added by the 'N'
 * extension.
 */


/* returns whether a CSR is defined and accessible at a given address
 * and privilege
 */
val ext_is_CSR_defined : (csreg, Privilege) -> bool effect {rreg}
scattered function ext_is_CSR_defined

/* returns the value of the CSR if it is defined */
val ext_read_CSR : csreg -> option(xlenbits) effect {rreg}
scattered function ext_read_CSR

/* returns new value (after legalisation) if the CSR is defined */
val ext_write_CSR : (csreg, xlenbits) -> option(xlenbits) effect {rreg, wreg, escape}
scattered function ext_write_CSR
