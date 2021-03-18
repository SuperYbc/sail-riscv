/*
 *
 *  Created on: Jan 2021
 *      Author: Dong Du
 */
#include <algorithm>
#include <string>
#include <iostream>
#include <sstream>
#include <fstream>

#include <stdlib.h>
#include <assert.h>

//#include "test_simple.h"
#include "test_spmp_ok_1.h"
#include "test_spmp_ok_share_1.h"
//#include "test_pmp_ok_1.h"
//#include "test_pmp_ok_share_1.h"
//#include "test_pmp_csr_1.h"

#define GEN_ALL 1

namespace {

const unsigned expected_files_count[] = {
        64-1,
 //       528,
 //       24,
        0
};

    std::ostringstream str_buffer, val_buffer;
    std::ofstream m_ofstream;
    unsigned cur_files_count = 0;
    unsigned cur_expected_errors = 0;

    const int max_pmp = 16;  // from spike
    const int max_pmp_cfg = max_pmp / 8;  // for RV64
};



int
main()
{
#if GEN_ALL //simple test case
#if 0
    spmp_simple_gen_class gen_class_1;

    for (int u_mode = 0; u_mode < 2; u_mode++) {
        for (int rw = 0; rw < 2; rw++) {
            for (int x = 0; x < 2; x++) {
                for (int cfgl = 0; cfgl < 2; cfgl++) {
                    for (int pmp_match = 0; pmp_match < 2; pmp_match++) {
    str_buffer.str("");
    str_buffer << "outputs/test_spmp_simple_u" << u_mode << "_rw" << rw << "_x" << x << "_l" << cfgl
            << "_match" << pmp_match << ".c";
    m_ofstream.open(str_buffer.str().c_str());
    cur_files_count++;

    gen_class_1.set_tag(str_buffer.str());

    unsigned rw_err = 0;
    unsigned x_err = 0;

    gen_class_1.set_switch_u_mode(u_mode);
    gen_class_1.set_pmp_rw(rw);
    gen_class_1.set_pmp_x(x);
    gen_class_1.set_pmp_l(cfgl);

    if (pmp_match) {
        gen_class_1.set_create_pmp_cfg(pmp_match);
        gen_class_1.set_pmp_addr_offset(0);
        if (u_mode == 1 || cfgl) {
            if (rw == 0) rw_err = 1;
            if (x == 0) x_err = 1;
        }
    } else {
        if (cur_files_count % 3 == 0) {
            gen_class_1.set_create_pmp_cfg(1);
            gen_class_1.set_pmp_addr_offset(0x100); // >= sizeof(.test) section
        } else {
            gen_class_1.set_create_pmp_cfg(0);
        }
        if (u_mode == 1) { // mmwp to against non-match
            rw_err = 1;
            x_err = 1;
        }
    }

    cur_expected_errors += rw_err + x_err;
    gen_class_1.set_expected_rw_fail(rw_err);
    gen_class_1.set_expected_x_fail(x_err);

    str_buffer.str("");
    gen_class_1.generate_spmp_simple(str_buffer, 0);
    str_buffer << std::endl;
    m_ofstream << str_buffer.str();
    m_ofstream.close();
                        }
                   }
              }
         }
    }
#endif
#endif

#if GEN_ALL //test case-1 (spmp ok)
#if 1
    spmp_ok_gen_class gen_class_1;

    for (int u_mode = 0; u_mode < 2; u_mode++) {
        for (int rw = 0; rw < 2; rw++) {
            for (int x = 0; x < 2; x++) {
              for (int sum = 0; sum < 2; sum++) {
                for (int cfgs = 0; cfgs < 2; cfgs++) {
                    for (int spmp_match = 0; spmp_match < 2; spmp_match++) {
			    /* skip some cases that are shared regions*/
			    if (rw ==0 && cfgs ==1 && x ==0){
				    //shared r/w/x regions
				    continue;
			    }
			    if (rw ==1 && cfgs ==1 && x ==1){
				    //shared data regions
				    continue;
			    }
			    /* end of skip*/

    str_buffer.str("");
    str_buffer << "outputs/test_spmp_ok_u" << u_mode << "_rw" << rw << "_x" << x << "_s" << cfgs
            << "_sum" << sum << "_match" << spmp_match << ".c";
    m_ofstream.open(str_buffer.str().c_str());
    cur_files_count++;

    gen_class_1.set_tag(str_buffer.str());

    unsigned rw_err = 0;
    unsigned x_err = 0;

    gen_class_1.set_switch_u_mode(u_mode);
    gen_class_1.set_spmp_rw(rw);
    gen_class_1.set_spmp_x(x);
    gen_class_1.set_spmp_s(cfgs);
    gen_class_1.set_sum(sum);

    if (spmp_match) {
        gen_class_1.set_create_spmp_cfg(spmp_match);
        gen_class_1.set_spmp_addr_offset(0);
        if (u_mode == 1 && !cfgs) { //u mode access u-mode regions
            if (rw == 0) rw_err = 1;
            if (x == 0) x_err = 1;
        } else if (u_mode == 0 && cfgs) { //s mode access s-mode regions
            if (rw == 0) rw_err = 1;
            if (x == 0) x_err = 1;
        } else if (u_mode == 1) { // u mode access s-mode regions
            rw_err = 1;
            x_err = 1;
	} else if (!u_mode) { // s mode access u-mode regions
		x_err = 1; //SMAP always enabled
		if (!sum || rw == 0){
			rw_err = 1;
		}
	}
    } else {
        if (cur_files_count % 3 == 0) {
            gen_class_1.set_create_spmp_cfg(1);
            gen_class_1.set_spmp_addr_offset(0x100); // >= sizeof(.test) section
        } else {
            gen_class_1.set_create_spmp_cfg(0);
        }
        if (u_mode == 1) {
            rw_err = 1;
            x_err = 1;
        }
    }

    cur_expected_errors += rw_err + x_err;
    gen_class_1.set_expected_rw_fail(rw_err);
    gen_class_1.set_expected_x_fail(x_err);

    str_buffer.str("");
    //gen_class_1.generate_spmp_simple(str_buffer, 0);
    gen_class_1.generate_spmp_ok(str_buffer, 0);
    str_buffer << std::endl;
    m_ofstream << str_buffer.str();
    m_ofstream.close();
                        }
                   }
              }
	    }
         }
    }
#endif
#endif

#if 1 //test case-2: spmp_ok_share
    spmp_ok_share_gen_class gen_class_2;

    /* Cases for rw(01) */
    for (int r = 0; r < 1; r++) {
        for (int x = 0; x < 2; x++) {
            for (int cfgs = 0; cfgs < 2; cfgs++) {
                for (int typex = 0; typex < 2; typex++) {
                    for (int umode = 0; umode < 2; umode++) {

    str_buffer.str("");
    str_buffer << "outputs/test_spmp_ok_share_r" << r << "_x" << x << "_cfgs" << cfgs
            << "_typex" << typex << "_umode" << umode << ".c";
    m_ofstream.open(str_buffer.str().c_str());
    cur_files_count++;

    gen_class_2.set_tag(str_buffer.str());

    unsigned r_err = 0;
    unsigned w_err = 0;
    unsigned x_err = 0;

    gen_class_2.set_spmp_r(r);
    gen_class_2.set_spmp_w(1);
    gen_class_2.set_spmp_x(x);
    gen_class_2.set_spmp_s(cfgs);
    gen_class_2.set_typex(typex);
    gen_class_2.set_enable_umode_test(umode);

    if (cfgs) {
         if (typex == 0) {
             if (x == 0) {
                 // no RW access
                 r_err = 1;
                 w_err = 1;
             } else {
                 // readable for M mode
                 if (umode) {
                     r_err = 1;
                     w_err = 1;
                 } else {
                     w_err = 1;
                 }
             }
         } else {
             // always executable
         }
     } else {
         if (typex == 0) {
             if (x == 0) {
                 // RW S mode, R for U
                 if (umode) {
                     w_err = 1;
                 }
             }
         } else {
             x_err = 1;  // when !cfgs, not executable
         }
     }

    cur_expected_errors += r_err + w_err + x_err;
    gen_class_2.set_expected_r_fail(r_err);
    gen_class_2.set_expected_w_fail(w_err);
    gen_class_2.set_expected_x_fail(x_err);

    str_buffer.str("");
    gen_class_2.generate_spmp_ok_share(str_buffer, 0);
    str_buffer << std::endl;
    m_ofstream << str_buffer.str();
    m_ofstream.close();
                    }
                }
            }
        }
    }

    /* Cases for srwx(1000) and srwx(1111) */
    for (int types =0; types <2; types++) { //types for srwx
    for (int typex = 0; typex < 2; typex++) {
           for (int umode = 0; umode < 2; umode++) {

    str_buffer.str("");
    str_buffer << "outputs/test_spmp_ok_share_types" << types
            << "_typex" << typex << "_umode" << umode << ".c";
    m_ofstream.open(str_buffer.str().c_str());
    cur_files_count++;

    gen_class_2.set_tag(str_buffer.str());

    unsigned r_err = 0;
    unsigned w_err = 0;
    unsigned x_err = 0;

    if (types == 0) {
   	 gen_class_2.set_spmp_r(0);
   	 gen_class_2.set_spmp_w(0);
   	 gen_class_2.set_spmp_x(0);
   	 gen_class_2.set_spmp_s(1);
   	 gen_class_2.set_typex(typex);
   	 gen_class_2.set_enable_umode_test(umode);
    }else {
   	 gen_class_2.set_spmp_r(1);
   	 gen_class_2.set_spmp_w(1);
   	 gen_class_2.set_spmp_x(1);
   	 gen_class_2.set_spmp_s(1);
   	 gen_class_2.set_typex(typex);
   	 gen_class_2.set_enable_umode_test(umode);
    
    }

    int x;
    x = types;
    //if (cfgs) {
         if (typex == 0) {
             if (x == 0) {
		     // always accessiable
             } else {
		     // always readable
                     w_err = 1;
             }
         } else {
             if (x == 1) {
                 x_err = 1;
             	// always not executable
	     }else{
             	// always executable
	     }
         }
     //} 

    cur_expected_errors += r_err + w_err + x_err;
    gen_class_2.set_expected_r_fail(r_err);
    gen_class_2.set_expected_w_fail(w_err);
    gen_class_2.set_expected_x_fail(x_err);

    str_buffer.str("");
    gen_class_2.generate_spmp_ok_share(str_buffer, 0);
    str_buffer << std::endl;
    m_ofstream << str_buffer.str();
    m_ofstream.close();
	   }
        }
    }

#endif

#if 0
#if GEN_ALL
    unsigned expectedCount = 0;
    for (int i=0; i<sizeof(expected_files_count)/sizeof(expected_files_count[0]); i++) {
        expectedCount += expected_files_count[i];
    }
    if (expectedCount != cur_files_count) {
        std::cerr << std::dec << "Total " << cur_files_count << " files generated, v.s. expected "
                << expectedCount << std::endl;
        exit(1);
    } else {
        std::cout << std::dec << "Total " << expectedCount << " files generated as expected." << std::endl;
    }
#endif
#else
        std::cout << std::dec << "Total " << cur_files_count << " files generated." << std::endl;
#endif
    printf("Generates expected errors %d.\n", cur_expected_errors);
    return 0;
}

