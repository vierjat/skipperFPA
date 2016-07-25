***** demo305_bkp3shft.asm for bkp 3
*****   DEF #CCDCLK      x06      * SLOT 2 + SLOT 3
*****   DEF #CCDACQ      x38      * SLOT 4 + SLOT 5  + SLOT 6
*****
***** 2011.01.14 i.karliner erase: restore V*DACs to 5.5, -2.5 (is 10, -1.5) 
***** 2011.01.12 i.karliner add ShiftLines subroutine for focus multiexposure mode
*****			    SEQVECTOR 32 => Shift only
*****			    # of lines:	 SHIFT_ROWS loop register 9
*****			                 loop register 11 also available             	 
***** 2010.11.07 w.stuermer Changed VSUB values for erase, per ECO on DA card
****  2010.10.20 i.karliner move syncing to a subroutine, run expose with sync, clear without sync
***** 2010.10.08 i.karliner use w.stuermer Vertical clocks restored to 10V (instead of 6.5V) after
*****                       Erase function
****  2010.09.29 i.karliner add erase_clear 
****  2010.06.30 i.karliner fix bug: remove State 10 in #SER_SGL_SHFT_TYPE1, #SER_SGL_SHFT_TYPE2
***** 2010.06.11 Added new expose/read/erase/clear function
*****
*****            Functions
*****
*****              PAN DO SEQVECTOR 1  => Normal Readout
*****              PAN DO SEQVECTOR 2  => Clear CCD (V_CLK only)
*****              PAN DO SEQVECTOR 4  => Erase CCD (V_CLK=8V, VSUB=0V)
*****              PAN DO SEQVECTOR 6  => Erase and Clear CCD 	
*****              PAN DO SEQVECTOR 8  => Expose, CCD Readout
*****              PAN DO SEQVECTOR 16 => Expose, CCD Readout, Erase, Clear
*****              PAN DO SEQVECTOR 32 => Vert Shift by # of lines
*****
*****              PAN DO SEQVECTOR 129,130,132,134, 136,144,160 => 
*****                                     Reverse clocks: Readout, Clear,
*****                                     Erase, Erase and Clear, Expose+Readout,
*****                                     Expose+Readout+Erase+Clear,
*****                                     Vert Shift by # of lines (same as 32), 
*****
*****            Current Loop register assignments
*****
*****              ROWS         0
*****              COLS         1
*****		   ROWBIN       2   
*****              COLBIN       3   Shutter open time (10 ms/count)
*****              ROWS_CLEAR   4   Number of rows to clear:
*****                                 ((DET ROWS / ROWBIN_CLEAR)
*****              ROWBIN_CLEAR 5   Binning for rows in CLEAR
*****              H_OVERLAP    6   Horizontal Clock overlap
*****              V_OVERLAP    7   Vertical Clock overlap
*****              INTEG_WIDTH  8   Integration time
*****              SHIFT_ROWS   9   N.rows shifted (multiple exposure f/focus tst)
*****              SW_WIDTH    10   Summing well width
*****              POST_SW     11   --> NOT USED <-- Time after summing well 
*****              ERASE_TIME  14   Time CCD is kept inverted (10 ms/count)
*****              POST_H_CLK  15   Time after H3 clock, before STATE_8A
*****
*****            Special functions for debugging
*****
*****              CAL #MARK_ZERO    => Sets VDD to 0V
*****              CAL #MARK         => Generates short pulse (5ms) on VDD
*****              CAL #TOGGLE_ALL_CLKS => Sets all clocks LOW, HIGH, LOW
*****
*****            Wait for Sync if MCB is slave
*****            Uses A,B and C clock groups
*****            Two phase collection
*****            Works with "SL2:CB,SL3:CB,SL4:ADC12,SL5:ADC12,SL6:ADC12"
*****
***** 2010.06.03 Added Inga's fast clear code.
*****
*****           Current Loop register assignments
*****    ROWS         0
*****    COLS         1
*****    ROWS_CLEAR   4   Number of rows to clear:
*****                       ((DET ROWS / ROWBIN_CLEAR)
*****    ROWBIN_CLEAR 5   Binning for rows in CLEAR
*****    H_OVERLAP    6   Horizontal Clock overlap
*****    V_OVERLAP    7   Vertical Clock overlap
*****    INTEG_WIDTH  8   Integration time
*****    SW_WIDTH    10   Summing well width
*****    POST_SW     11   Time after summing well
*****    ERASE_TIME  14   Time CCD is kept inverted (10 ms/count)
*****    POST_H_CLK  15   Time after H3 clock, before STATE_8A
*****
***** 2010.05.25 For ERASE function
*****               erase_time  =>  Time spent in inversion, in ms 
*****               do expvector 4
*****               ** Restore VSUB, V1_HighDac, V1_LowDac to nominal values
*****
*****            For EXPOSE function
*****               colbin  =>  Open shutter for n * 10 ms 
*****
***** 2010.04.20 Use new ERASE sequence, VSUB on/off sequence
*****           a) Ramp VSUB to 10V
*****           b) Set  VCLK DACs to 8V
*****           c) Ramp VSUB to 0V
*****           d) Wait
*****           e) Ramp VSUB to 10V
*****           f) Set  VCLK DACs to +6.5/-1.5 V
*****           g) Ramp VSUB to 40V
*****
***** 2009.11.23 Adds CLEAR, ERASE, EXPOSE functions
*****              EXPCODE 1  => Normal Readout
*****              EXPCODE 2  => Clear CCD (V_CLK only)
*****              EXPCODE 4  => Erase CCD (V_CLK=8V, VSUB=0V)
*****              EXPCODE 8  => Expose, CCD Readout
*****              EXPCODE 129,130,132,136 => 
*****                            Reverse clocks: Readout, Clear,
*****                            Erase, Expose+Readout
*****            Wait for Sync if MCB is slave
*****            Uses A,B and C clock groups
*****            Two phase collection
*****            Works with "SL2:CB,SL3:CB,SL4:ADC12,SL5:ADC12,SL6:ADC12"
*****
***** 2009.06.02 Works with "SL2:CB,SL3:CB,SL4:ADC12,SL5:ADC12,SL6:ADC12"
*****
***** 2009.04.13 Works with "SL2:CB,4:ADC12,5:ADC12"
*****
***** 2009.04.08 Made changes, per I. Karliner's note, to provide
*****            MCB Synchronization between crates.
*****
***** 2009.04.03 Uncommented POST_H_CLK programmable delay, so as to work
*****            with the Madrid Clock Board, minus the comp capacitors
*****            that slow down the clocks. Also made READTYPE_2 compatible
*****            with READTYPE_1 readout (commented out corresponding delays).
*****
***** 2009.03.16 Use groups A,B,C; change CB and ADC12 card
*****            addresses for cards-"1:MCB,2:CB,4:ADC12,5:ADC12"
*****
***** 2009.01.29 Use groups A,B and C; change CB and ADC12 card
*****            addresses for cards="1:MCB,2:CB,3:CB,4:ADC12,5:ADC12,6:ADC12"
*****
***** 2008.06.16 Changed to use A and B group of clocks only; C
***** group is reserved for the shutter.
*****
***** Most recent modification 06/June/2006
***** State1 is commented out and RG executes in parallel with H1 clock.
***** Note that RG is the same width as H1!
*****
***** This version of the Monsoon sequencer code has been constructed to
***** conform with the FNAL_2 definition of the CLKPORT register and offer
***** parameterized control for the following via the use of Monsoon
***** Engineering Console (MEC) accessible Loop Registers:
*****
***** ROWS         0
***** COLS         1
***** ROWBIN       2
***** COLBIN       3
***** RG_WIDTH     4
***** POST_RG      5
***** H_OVERLAP    6   Horizontal Clock overlap
***** V_OVERLAP    7   Vertical Clock overlap
***** INTEG_WIDTH  8   Integration time
***** PRE_SW       9   Settling time after polarity (replaced)
***** SW_WIDTH    10   Summing well width
***** POST_SW     11   Time after summing well
***** PRE_CTC     12   Time before CTC
***** POST_CTC    13   Time after CTC
***** CLEAR_CNT   14   Number of clear operations
***** POST_H_CLK  15   Time after H3 clock, before STATE_8A
*****
*****
***** The following values for "expVector" are used to start the
***** selected program functions:
*****
***** VCTR_1          -> Read            - CCD Type 1
***** VCTR_2          -> Clear           - CCD Type 1
***** VCTR_3          -> ClearExposeRead - CCD Type 1
***** VCTR_8 + VCRT_1 -> Read            - CCD Type 2
***** VCTR_8 + VCTR_2 -> Clear           - CCD Type 2
***** VCTR_8 + VCTR_3 -> ClearExposeRead - CCD Type 2
*****
*****
***** HISTORY     : VERSION 0 --
*****             : VERSION 1 -- I. KARLINER **V1 4-22-05
*****             : VERSION 2 -- W. STUERMER      5-13-05
*****             : VERSION 3 -- W. STUERMER      6-14-05
*****             : VERSION 4 -- W. STUERMER     12-29-05

**************************************************************
**                                                          **
**             CONSTANT DEFINITIONS                         **
**                                                          **
**************************************************************


**************************************************************
** Jump flag constants - Bit positions in CMD (Command) Register
**************************************************************

DEF #SYNC        1                  * Jump on sync bit high
DEF #ITC         2                  * Jump on Integration time expired
DEF #START       3                  * Jump on start exposure flag set
DEF #VCTR_1      4                  * Jump on start vector bit value   1
DEF #VCTR_2      5                  * Jump on start vector bit value   2
DEF #VCTR_3      6                  * Jump on start vector bit value   4
DEF #VCTR_4      7                  * Jump on start vector bit value   8
DEF #VCTR_5      8                  * Jump on start vector bit value  16
DEF #VCTR_6      9                  * Jump on start vector bit value  32
DEF #VCTR_7     10                  * Jump on start vector bit value  64
DEF #VCTR_8     11                  * Jump on start vector bit value 128
DEF #CONTRUN    12
DEF #USR1FLAG   13
DEF #USR2FLAG   14
DEF #USR3FLAG   15

*******************************
** EFR Reg constants         **
*******************************

DEF #KILL_EXPFLG    x00000001    * Cancel start exposure flag using the EFR
                                 *   register
DEF #STRT_INTCNTR   x00000002    * Start the integration time counter using
                                 *   the EFR register
DEF #STOP_INTCNTR   x00000004    * Stop the integration time counter using
                                 *   the EFR register
DEF #LSR_AUTO_KILL  x00000100    * Enables automatic board select cancel
                                 *   after an LSR instruction
DEF #LSR_MAN_RESET  x00000200    * sables automatic board select cancel.
                                 *   LSR will remain active until an LSR
                                 *   #DSLCT is issued
DEF #SET_SYNC_LOW   x00004000    * If enabled as master DHE, set sync bit low
                                 *   after sync delay
DEF #SET_SYNC_HIGH  x00008000    * If enabled as master DHE, set sync signal
                                 *   high immediately
DEF #KILLANDSYNC    x00004001    * Set sync low and kill start exposure flag

*******************************
** Mode register constants   **
*******************************

DEF #RESET       0                  * Mode register constant for board
                                    *   reset operation
DEF #READ        1                  * Mode register constant for read operation
DEF #WRITE16     2                  * Mode register constant for 16 bit write
                                    *   operation
DEF #WRITE32     3                  * Mode register constant for 32 bit write
                                    *   operation
**
**********************************
** LSR Board select assignments **
**********************************

DEF #DSLCT       x00
DEF #MCB         x01
DEF #CCDCLK      x06      * SLOT 2 + SLOT 3
DEF #CCDACQ      x38      * SLOT 4 + SLOT 5  + SLOT 6
*DEF #CCDCLK      x04      * SLOT 3
*DEF #CCDACQ      x10      * SLOT 5

********************************
** LOOP REGISTER assignments  **
********************************

DEF #ROWS          0       * NUMBER OF ROWS TO READOUT
                           *  ((DET ROWS - SKIPROW)/ ROWBIN)
DEF #COLS          1       * NUMBER OF COLUMNS TO READOUT
                           *   ((DET COLS - SKIPCOL) / COLBIN)
DEF #ROWBIN        2       * BINNING FACTOR FOR ROWS
DEF #COLBIN        3       * BINNING FACTOR FOR COLS
DEF #ROWS_CLEAR    4       * RESET_GATE width (100ns units)
DEF #ROWBIN_CLEAR  5       * Time after RESET_GATE (100ns units)
DEF #H_OVERLAP     6       * Time between phases of Horizontal clock
DEF #V_OVERLAP     7       * Time between phases of Vertical clock
DEF #INTEG_WIDTH   8       * Integration time (100ns units)
DEF #SHIFT_ROWS    9       * Number of rows to shift w-out digitizing
*DEF #PRE_SW        9      * Time for settling after polarity
DEF #SW_WIDTH     10       * SUMMING_WELL width (100ns units)
DEF #POST_SW      11       * Time after SUMMING_WELL (100ns units)
DEF #PRE_CTC      12       * Time after integration, before CTC
DEF #POST_CTC     13       * Time after CTC, before next pixel
DEF #ERASE_TIME   14       * Number of clear operations to perform before read
DEF #POST_H_CLK   15       * Time after H3 clock, before STATE8A

***********************************
** CB BOARD ADDRESS POINTERS     **
***********************************

DEF #CLKPORT     x0000
DEF #FBIAS0123   x0001
DEF #FBIAS4567   x0002
DEF #DEVICE0     x0000

* Address put in [31:16] for 16-bit writes

DEF #A_V1_HIGH   x01000000
DEF #A_V1_LOW    x01010000
DEF #A_V2_HIGH   x01020000
DEF #A_V2_LOW    x01030000
DEF #A_V3_HIGH   x01040000
DEF #A_V3_LOW    x01050000

DEF #B_V1_HIGH   x01200000
DEF #B_V1_LOW    x01210000
DEF #B_V2_HIGH   x01220000
DEF #B_V2_LOW    x01230000
DEF #B_V3_HIGH   x01240000
DEF #B_V3_LOW    x01250000

DEF #C_V1_HIGH   x01400000
DEF #C_V1_LOW    x01410000
DEF #C_V2_HIGH   x01420000
DEF #C_V2_LOW    x01430000
DEF #C_V3_HIGH   x01440000
DEF #C_V3_LOW    x01450000

***********************************
** DATA TO OPEN/CLOSE SHUTTER    **
***********************************
* Address put in [31:16] for 16-bit writes
DEF #CLK_MUXSLCT      0x01FF0000

DEF #OPEN_SHUTTER     #CLK_MUXSLCT OR 0x8000
DEF #CLOSE_SHUTTER    #CLK_MUXSLCT OR 0x0

***********************************
** CB BOARD ADDRESS POINTERS     **
***********************************
* Addresses for 32-bit registers

DEF #CDSREG      x0000
DEF #DOPREG      x0001
DEF #BRSTCMD     x0004

* Address put in [31:16] for 16-bit writes

DEF #VSUB_LIMIT  x02200000
DEF #VSUB_SLEW   x02210000
DEF #AUXCFG      x02800000
DEF #VSUB_ENBL   xFFF80000
DEF #VDD_DAC     x02480000

*************************************
** DATA VALUES FOR CB AND DA BOARD **
*************************************

DEF #VSUB_LIM_0V        x333
DEF #VSUB_SLEW_12V      x709
DEF #VSUB_LIM_40V       xfff
DEF #VSUB_LIM_10V       x3ff
DEF #VSUB_EN_0          0
DEF #VSUB_EN_1          1
DEF #AUXCFG_VSUB_ON     7
DEF #AUXCFG_VSUB_OFF    3
DEF #VCLK_8V           212
DEF #VCLK_5_5V         186
DEF #VCLK_6_5V         197
DEF #VCLK_10V          233
DEF #VCLK_MINUS_1_5V   112
DEF #VCLK_MINUS_2_5V   101
DEF #SLEW_RATE         12      * Time per step in ms
DEF #DAC_DELAY         100     * Delay in us, after DAC write

*************************************
** PATTERN WORDS FOR ERASE SEQUENCE**
*************************************

*****           a) Ramp VSUB to 0
*****           b) Ramp VSUB to 10V
*****           c) Set  VCLK DACs to 8V
*****           d) Ramp VSUB to 0V
*****           e) Wait
*****           f) Ramp VSUB to 10V
*****           g) Set  VCLK DACs to +6.5/-1.5 V
*****           h) Ramp VSUB to 0V
*****           i) Ramp VSUB to 40V

DEF #STATE_VDD_HIGH  #VDD_DAC     OR x800
DEF #STATE_VDD_LOW   #VDD_DAC     OR x00

DEF #STATE_VSUB_ON   #VSUB_ENBL   OR x01
DEF #STATE_VSUB_OFF  #VSUB_ENBL   OR x00

** A) Ramp VSUB to 10V

DEF #ERASE_STATE_1    #VSUB_LIMIT OR 3978    ** 39.000000 volts
DEF #ERASE_STATE_2    #VSUB_LIMIT OR 3876    ** 38.000000 volts
DEF #ERASE_STATE_3    #VSUB_LIMIT OR 3774    ** 37.000000 volts
DEF #ERASE_STATE_4    #VSUB_LIMIT OR 3672    ** 36.000000 volts
DEF #ERASE_STATE_5    #VSUB_LIMIT OR 3570    ** 35.000000 volts
DEF #ERASE_STATE_6    #VSUB_LIMIT OR 3468    ** 34.000000 volts
DEF #ERASE_STATE_7    #VSUB_LIMIT OR 3366    ** 33.000000 volts
DEF #ERASE_STATE_8    #VSUB_LIMIT OR 3264    ** 32.000000 volts
DEF #ERASE_STATE_9    #VSUB_LIMIT OR 3162    ** 31.000000 volts
DEF #ERASE_STATE_10   #VSUB_LIMIT OR 3060    ** 30.000000 volts
DEF #ERASE_STATE_11   #VSUB_LIMIT OR 2958    ** 29.000000 volts
DEF #ERASE_STATE_12   #VSUB_LIMIT OR 2856    ** 28.000000 volts
DEF #ERASE_STATE_13   #VSUB_LIMIT OR 2754    ** 27.000000 volts
DEF #ERASE_STATE_14   #VSUB_LIMIT OR 2652    ** 26.000000 volts
DEF #ERASE_STATE_15   #VSUB_LIMIT OR 2550    ** 25.000000 volts
DEF #ERASE_STATE_16   #VSUB_LIMIT OR 2448    ** 24.000000 volts
DEF #ERASE_STATE_17   #VSUB_LIMIT OR 2346    ** 23.000000 volts
DEF #ERASE_STATE_18   #VSUB_LIMIT OR 2244    ** 22.000000 volts
DEF #ERASE_STATE_19   #VSUB_LIMIT OR 2142    ** 21.000000 volts
DEF #ERASE_STATE_20   #VSUB_LIMIT OR 2040    ** 20.000000 volts
DEF #ERASE_STATE_21   #VSUB_LIMIT OR 1938    ** 19.000000 volts
DEF #ERASE_STATE_22   #VSUB_LIMIT OR 1836    ** 18.000000 volts
DEF #ERASE_STATE_23   #VSUB_LIMIT OR 1734    ** 17.000000 volts
DEF #ERASE_STATE_24   #VSUB_LIMIT OR 1632    ** 16.000000 volts
DEF #ERASE_STATE_25   #VSUB_LIMIT OR 1530    ** 15.000000 volts
DEF #ERASE_STATE_26   #VSUB_LIMIT OR 1428    ** 14.000000 volts
DEF #ERASE_STATE_27   #VSUB_LIMIT OR 1326    ** 13.000000 volts
DEF #ERASE_STATE_28   #VSUB_LIMIT OR 1224    ** 12.000000 volts
DEF #ERASE_STATE_29   #VSUB_LIMIT OR 1122    ** 11.000000 volts
DEF #ERASE_STATE_30   #VSUB_LIMIT OR 1020    ** 10.000000 volts

** B) CHANGE V_CLK (8V)

DEF #ERASE_STATE_100  #A_V1_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_101  #A_V1_LOW    OR #VCLK_8V
DEF #ERASE_STATE_102  #A_V2_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_103  #A_V2_LOW    OR #VCLK_8V
DEF #ERASE_STATE_104  #A_V3_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_105  #A_V3_LOW    OR #VCLK_8V
DEF #ERASE_STATE_106  #B_V1_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_107  #B_V1_LOW    OR #VCLK_8V
DEF #ERASE_STATE_108  #B_V2_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_109  #B_V2_LOW    OR #VCLK_8V
DEF #ERASE_STATE_110  #B_V3_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_111  #B_V3_LOW    OR #VCLK_8V
DEF #ERASE_STATE_112  #C_V1_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_113  #C_V1_LOW    OR #VCLK_8V
DEF #ERASE_STATE_114  #C_V2_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_115  #C_V2_LOW    OR #VCLK_8V
DEF #ERASE_STATE_116  #C_V3_HIGH   OR #VCLK_8V
DEF #ERASE_STATE_117  #C_V3_LOW    OR #VCLK_8V

** C) Ramp VSUB to 0V

DEF #ERASE_STATE_200  #VSUB_LIMIT OR  918    ** 9.000000 volts
DEF #ERASE_STATE_201  #VSUB_LIMIT OR  816    ** 8.000000 volts
DEF #ERASE_STATE_202  #VSUB_LIMIT OR  714    ** 7.000000 volts
DEF #ERASE_STATE_203  #VSUB_LIMIT OR  612    ** 6.000000 volts
DEF #ERASE_STATE_204  #VSUB_LIMIT OR  510    ** 5.000000 volts
DEF #ERASE_STATE_205  #VSUB_LIMIT OR  408    ** 4.000000 volts
DEF #ERASE_STATE_206  #VSUB_LIMIT OR  306    ** 3.000000 volts
DEF #ERASE_STATE_207  #VSUB_LIMIT OR  204    ** 2.000000 volts
DEF #ERASE_STATE_208  #VSUB_LIMIT OR  102    ** 1.000000 volts
DEF #ERASE_STATE_209  #VSUB_LIMIT OR    5    ** 0.000000 volts (***WAS 0 CNT***)

**  D) Ramp VSUB to 10V

DEF #ERASE_STATE_300   #VSUB_LIMIT OR  102    ** 1.000000 volts
DEF #ERASE_STATE_301   #VSUB_LIMIT OR  204    ** 2.000000 volts
DEF #ERASE_STATE_302   #VSUB_LIMIT OR  306    ** 3.000000 volts
DEF #ERASE_STATE_303   #VSUB_LIMIT OR  408    ** 4.000000 volts
DEF #ERASE_STATE_304   #VSUB_LIMIT OR  510    ** 5.000000 volts
DEF #ERASE_STATE_305   #VSUB_LIMIT OR  612    ** 6.000000 volts
DEF #ERASE_STATE_306   #VSUB_LIMIT OR  714    ** 7.000000 volts
DEF #ERASE_STATE_307   #VSUB_LIMIT OR  816    ** 8.000000 volts
DEF #ERASE_STATE_308   #VSUB_LIMIT OR  918    ** 9.000000 volts
DEF #ERASE_STATE_309   #VSUB_LIMIT OR 1020    ** 10.000000 volts

** E) RESTORE V_CLK

DEF #ERASE_STATE_350  #A_V1_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_351  #A_V2_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_352  #A_V3_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_353  #A_V1_LOW    OR #VCLK_MINUS_2_5V
DEF #ERASE_STATE_354  #A_V2_LOW    OR #VCLK_MINUS_2_5V
DEF #ERASE_STATE_355  #A_V3_LOW    OR #VCLK_MINUS_2_5V
DEF #ERASE_STATE_356  #B_V1_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_357  #B_V2_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_358  #B_V3_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_359  #B_V1_LOW    OR #VCLK_MINUS_2_5V
DEF #ERASE_STATE_360  #B_V2_LOW    OR #VCLK_MINUS_2_5V
DEF #ERASE_STATE_361  #B_V3_LOW    OR #VCLK_MINUS_2_5V
DEF #ERASE_STATE_362  #C_V1_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_363  #C_V2_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_364  #C_V3_HIGH   OR #VCLK_5_5V
DEF #ERASE_STATE_365  #C_V1_LOW    OR #VCLK_MINUS_2_5V
DEF #ERASE_STATE_366  #C_V2_LOW    OR #VCLK_MINUS_2_5V
DEF #ERASE_STATE_367  #C_V3_LOW    OR #VCLK_MINUS_2_5V

** F) Ramp VSUB to 40V

DEF #ERASE_STATE_400   #VSUB_LIMIT OR 1122    ** 11.000000 volts
DEF #ERASE_STATE_401   #VSUB_LIMIT OR 1224    ** 12.000000 volts
DEF #ERASE_STATE_402   #VSUB_LIMIT OR 1326    ** 13.000000 volts
DEF #ERASE_STATE_403   #VSUB_LIMIT OR 1428    ** 14.000000 volts
DEF #ERASE_STATE_404   #VSUB_LIMIT OR 1530    ** 15.000000 volts
DEF #ERASE_STATE_405   #VSUB_LIMIT OR 1632    ** 16.000000 volts
DEF #ERASE_STATE_406   #VSUB_LIMIT OR 1734    ** 17.000000 volts
DEF #ERASE_STATE_407   #VSUB_LIMIT OR 1836    ** 18.000000 volts
DEF #ERASE_STATE_408   #VSUB_LIMIT OR 1938    ** 19.000000 volts
DEF #ERASE_STATE_409   #VSUB_LIMIT OR 2040    ** 20.000000 volts
DEF #ERASE_STATE_410   #VSUB_LIMIT OR 2142    ** 21.000000 volts
DEF #ERASE_STATE_411   #VSUB_LIMIT OR 2244    ** 22.000000 volts
DEF #ERASE_STATE_412   #VSUB_LIMIT OR 2346    ** 23.000000 volts
DEF #ERASE_STATE_413   #VSUB_LIMIT OR 2448    ** 24.000000 volts
DEF #ERASE_STATE_414   #VSUB_LIMIT OR 2550    ** 25.000000 volts
DEF #ERASE_STATE_415   #VSUB_LIMIT OR 2652    ** 26.000000 volts
DEF #ERASE_STATE_416   #VSUB_LIMIT OR 2754    ** 27.000000 volts
DEF #ERASE_STATE_417   #VSUB_LIMIT OR 2856    ** 28.000000 volts
DEF #ERASE_STATE_418   #VSUB_LIMIT OR 2958    ** 29.000000 volts
DEF #ERASE_STATE_419   #VSUB_LIMIT OR 3060    ** 30.000000 volts
DEF #ERASE_STATE_420   #VSUB_LIMIT OR 3162    ** 31.000000 volts
DEF #ERASE_STATE_421   #VSUB_LIMIT OR 3264    ** 32.000000 volts
DEF #ERASE_STATE_422   #VSUB_LIMIT OR 3366    ** 33.000000 volts
DEF #ERASE_STATE_423   #VSUB_LIMIT OR 3468    ** 34.000000 volts
DEF #ERASE_STATE_424   #VSUB_LIMIT OR 3570    ** 35.000000 volts
DEF #ERASE_STATE_425   #VSUB_LIMIT OR 3672    ** 36.000000 volts
DEF #ERASE_STATE_426   #VSUB_LIMIT OR 3774    ** 37.000000 volts
DEF #ERASE_STATE_427   #VSUB_LIMIT OR 3876    ** 38.000000 volts
DEF #ERASE_STATE_428   #VSUB_LIMIT OR 3978    ** 39.000000 volts
DEF #ERASE_STATE_429   #VSUB_LIMIT OR 4080    ** 40.000000 volts

***********************************
** CDS REGISTER  Control Data    **
***********************************

DEF #CDS_ADR       b1111111100000000    * Acti## PAN Attribute Namvate all channels on this board
DEF #CDS_GBL       b1000000000000000    * Global address strb for CTC and FP Trig
DEF #CDS_CTC       b0000000000000001    * Trigger an ADC conversion cycle
DEF #CDS_INV       b0000000000000010    * Connect the Inverted the signal
DEF #CDS_NIN       b0000000000000100    * Connect the Non-Inverted the signal
DEF #CDS_INT       b0000000000001000    * Inte## PAN Attribute Namgrate
DEF #CDS_DCR       b0000000000010000    * Apply the DC Restore clamp
DEF #CDS_RST       b0000000000100000    * Reset the integrator
DEF #CDS_TFP       b0000000001000000    * Trigger the front panel test point

************************************## PAN Attribute Nam
** CLKPORT REGISTER  Control Data **
************************************

* Patterns to control A,B and C groups of CCDs:

DEF #NGUARD        h80000000 ** CHECK IF THIS IS NEEDED

* v===================SKIPPER===================v
DEF #SK_H2     b01000000000000000000000000000000 * GR0-H2


*DEF #SK_H3L    b00000000000000000011000000000000 * GR0-H1A/B
*DEF #SK_H1L    b00000000000000001100000000000000 * GR0-H3A/B

DEF #SK_H1L    b00000000000000000011000000000000 * GR0-H1A/B
DEF #SK_H3L    b00000000000000001100000000000000 * GR0-H3A/B
DEF #SK_RGL    b00000000000000010000000000000000 * GR0-RG
DEF #SK_SWL    b00000000000000100000000000000000 * GR0-SW
DEF #SK_OGL    b00000011000000000000000000000000 * GR6-H1A/B
DEF #SK_DGL    b00001100000000000000000000000000 * GR6-H3A/B


*DEF #SK_V3L    b00000000000000000000000000000001 * GR0-V1
*DEF #SK_V1L    b00000000000000000000000000000100 * GR0-V3

DEF #SK_V1L    b00000000000000000000000000000001 * GR0-V1
DEF #SK_V2L    b00000000000000000000000000000010 * GR0-V2
DEF #SK_V3L    b00000000000000000000000000000100 * GR0-V3
DEF #SK_TGL    b00000000000000000000000000001000 * GR0-TG


*DEF #SK_H3U    b00000000000011000000000000000000 * GR3-H1A/B
*DEF #SK_H1U    b00000000001100000000000000000000 * GR3-H3A/B

DEF #SK_H1U    b00000000000011000000000000000000 * GR3-H1A/B
DEF #SK_H3U    b00000000001100000000000000000000 * GR3-H3A/B
DEF #SK_RGU    b00000000010000000000000000000000 * GR3-RG
DEF #SK_SWU    b00000000100000000000000000000000 * GR3-SW
DEF #SK_OGU    b00010000000000000000000000000000 * GR6-RG
DEF #SK_DGU    b00100000000000000000000000000000 * GR6-SW

*DEF #SK_V3U    b00000000000000000000000000010000 * GR3-V1
*DEF #SK_V1U    b00000000000000000000000001000000 * GR3-V3

DEF #SK_V1U    b00000000000000000000000000010000 * GR3-V1
DEF #SK_V2U    b00000000000000000000000000100000 * GR3-V2
DEF #SK_V3U    b00000000000000000000000001000000 * GR3-V3
DEF #SK_TGU    b00000000000000000000000010000000 * GR3-TG


* SERIAL REGISTER STATES
DEF #SK_SW   #SK_SWL OR #SK_SWU
DEF #SK_OG   #SK_OGL OR #SK_OGU
DEF #SK_DG   #SK_DGL OR #SK_DGU
DEF #SK_RG   #SK_RGL OR #SK_RGU

* VERTICAL STATES
DEF #SK_V1   #SK_V1L OR #SK_V1U
DEF #SK_V2   #SK_V2L OR #SK_V2U
DEF #SK_V3   #SK_V3L OR #SK_V3U
DEF #SK_TG   #SK_TGL OR #SK_TGU

* CHARGE ACCUMULATION STATES
DEF #SK_VCLK_0   #SK_TG  OR #SK_V1  OR #SK_V3
DEF #SK_HCLK_0   #SK_H1L OR #SK_H1U OR #SK_H3L OR #SK_H3U OR #SK_SW ** SHOULD WE KEEP SW UP?

* SHIFT FROM V1 -> V3
DEF #STATE_11   #SK_HCLK_0  OR #SK_V1 OR           #SK_V3
DEF #STATE_12   #SK_HCLK_0  OR #SK_V1
DEF #STATE_13   #SK_HCLK_0  OR #SK_V1 OR #SK_V2
DEF #STATE_14   #SK_HCLK_0  OR           #SK_V2
DEF #STATE_15   #SK_HCLK_0  OR           #SK_V2 OR #SK_V3
DEF #STATE_16   #SK_HCLK_0  OR                     #SK_V3 OR #SK_TG
DEF #STATE_17   #SK_HCLK_0  OR #SK_V1           OR #SK_V3 OR #SK_TG


**** SR: 321
**** L1: <- 
**** U1: -> 
DEF #STATE_0    #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR           #SK_H3U OR #SK_H3L OR           #SK_H1U OR #SK_H1L 
DEF #STATE_3    #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR           #SK_H3U OR                                 #SK_H1L 
DEF #STATE_4    #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR           #SK_H3U OR            #SK_H2 OR            #SK_H1L 
DEF #STATE_5    #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR                                 #SK_H2
DEF #STATE_6    #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR                      #SK_H3L OR #SK_H2 OR #SK_H1U
DEF #STATE_7    #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR                      #SK_H3L OR           #SK_H1U
DEF #STATE_8DG  #SK_VCLK_0  OR #SK_OG OR                               #SK_H3U OR #SK_H3L OR           #SK_H1U OR #SK_H1L
DEF #STATE_8    #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR           #SK_H3U OR #SK_H3L OR           #SK_H1U OR #SK_H1L
DEF #STATE_9    #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR #SK_SW OR #SK_H3U OR #SK_H3L OR           #SK_H1U OR #SK_H1L
DEF #STATE_10   #SK_VCLK_0  OR #SK_OG OR #SK_DG OR #SK_RG OR           #SK_H3U OR #SK_H3L OR           #SK_H1U OR #SK_H1L
DEF #STATE_10OG #SK_VCLK_0  OR           #SK_DG OR #SK_RG OR           #SK_H3U OR #SK_H3L OR           #SK_H1U OR #SK_H1L
DEF #STATE_10RG #SK_VCLK_0  OR #SK_OG OR #SK_DG OR        OR           #SK_H3U OR #SK_H3L OR           #SK_H1U OR #SK_H1L


* ^===================SKIPPER===================^

DEF #ALL_CLKS_HIGH  xFFFFFFFF
DEF #ALL_CLKS_LOW   x00000000

**** LEGACY DEF, SHOULD BE REMOVED
**** HORIZONTAL SCAN
DEF #STATE_1    #ALL_CLKS_LOW
DEF #STATE_2    #ALL_CLKS_LOW
**** HORIZONTAL SCAN FOR TYPE2 CCDs 
DEF #R_STATE_3  #ALL_CLKS_LOW
DEF #R_STATE_4  #ALL_CLKS_LOW
DEF #R_STATE_6  #ALL_CLKS_LOW
DEF #R_STATE_7  #ALL_CLKS_LOW

*************************************
** CDS BIT DEFINITIONS             **
*************************************

DEF #CDS_ADR    b1111111100000000     * Channel address of CDS (0x100 = channel 0, 0x200 = channel 1, 0x300 = channel 0 and 1, etc.).
DEF #CDS_GBL    b1000000000000000     * Global address strobe for CTC and FP Trigger
DEF #CDS_CTC    b0000000000000001     * Trigger an ADC conversion cycle
DEF #CDS_INV    b0000000000000010     * Connect the Inverted the signal
DEF #CDS_NIN    b0000000000000100     * Connect the Non-Inverted the signal
DEF #CDS_INT    b0000000000001000     * Integrate
DEF #CDS_DCR    b0000000000010000     * Apply the DC Restore clamp
DEF #CDS_RST    b0000000000100000     * Reset the integrator
DEF #CDS_TFP    b0000000001000000     * Trigger the front panel test point

*************************************
* DATA FOR CDS REGISTER            **
*************************************

DEF #STATE_0A   #CDS_ADR OR #CDS_NIN OR           #CDS_RST OR #CDS_DCR
DEF #STATE_8A   #CDS_ADR OR #CDS_NIN
DEF #STATE_8B   #CDS_ADR OR #CDS_NIN OR #CDS_INT
DEF #STATE_8C   #CDS_ADR OR #CDS_NIN
DEF #STATE_8D   #CDS_ADR
DEF #STATE_8E   #CDS_ADR OR #CDS_INV
DEF #STATE_10A  #CDS_ADR OR #CDS_INV OR #CDS_INT
DEF #STATE_10B  #CDS_ADR OR #CDS_INV
DEF #STATE_10C  #CDS_GBL OR #CDS_INV OR           #CDS_CTC
DEF #STATE_10D  #CDS_ADR OR #CDS_INV
DEF #STATE_10E  #CDS_ADR OR #CDS_NIN OR           #CDS_RST OR #CDS_DCR

********************************
** DELAY CONSTANTS            **
********************************

DEF #DELAY_256ms   255   * 255.0 ms
DEF #DELAY_119ms   119   * 119.0 ms
DEF #DELAY_64ms     64   *  64.0 ms
DEF #DELAY_60ms     60   *  60.0 ms
DEF #DELAY_120ms   120   * 120.0 ms

DEF #DELAY_20us    20    * 20.0 us
DEF #DELAY_10us    10    * 10.0 us
DEF #DELAY_4us      4    *  4.0 us
DEF #DELAY_1us      1    *  1.0 us

DEF #DELAY_8000ns 160    *  8.0 us
DEF #DELAY_7100ns 144    *  7.1 us
DEF #DELAY_2400ns  48    *  2.4 us
DEF #DELAY_2300ns  46    *  2.3 us    * SER_OVERLAP
DEF #DELAY_2200ns  44    *  2.2 us
DEF #DELAY_2000ns  40    *  2.0 us    * SER_OVERLAP
DEF #DELAY_1600ns  32    *  1.6 us
DEF #DELAY_1000ns  20    *  1.0 us    * INTEGRATE
DEF #DELAY_700ns   14    *  0.7 us
DEF #DELAY_500ns   10    *  0.5 us    * Settling before CTC
DEF #DELAY_200ns    4    *  0.2 us    * VIDEO DUMP
DEF #DELAY_100ns    2    *  0.1 us

DEF #DELAY_17us    17    * 17.6 us
DEF #DELAY_600ns   12

DEF #DELAY_18us    18    * 18.4 us
DEF #DELAY_400ns    8    *

DEF #DELAY_20us    20    * 20.0 us    * VERT_OVERLAP
DEF #DELAY_18us    18    * 18.0 us

********************************
** PATTERN MEMORY DEFINITIONS **
********************************

** PATTERN MEMORY SEGMENTATION MAP
DEF #PATSEG_00      x0000             * Initialization stuff - for example
DEF #PATSEG_CLR     x0020             * CCD CLEAR VECTORS - for example
DEF #PATSEG_INIT    x0040             * CCD READ INITIALIZATION - for example
DEF #PATSEG_PAR     x0060             * CCD PARALLEL SHIFT VECTORS - for example
DEF #PATSEG_SER     x0080             * CCD SERIAL SHIFT VECTORS - for example
DEF #PATSEG_CDS     x00A0             * CCD CDS OPERATION VECTORS - for example

********************************
** INITIALIZE PATTERN MEMORY  **
********************************

* We can use the same label name here because they are in different contexts
* The definition earlier points to a data value. The label here points to
* a pattern memory address that contains the actual pattern data

ORG PAT #PATSEG_00

***General constants ***

PAT #KILL_EXPFLG    #KILL_EXPFLG
PAT #STRT_INTCNTR   #STRT_INTCNTR
PAT #STOP_INTCNTR   #STOP_INTCNTR
PAT #SET_SYNC_HIGH  #SET_SYNC_HIGH
PAT #SET_SYNC_LOW   #SET_SYNC_LOW


***Data for CDS and CLKPORT Registers ***

** ORG PAT #PATSEG_SER
PAT #ALL_CLKS_HIGH    #ALL_CLKS_HIGH 
PAT #ALL_CLKS_LOW     #ALL_CLKS_LOW

PAT #OPEN_SHUTTER     #OPEN_SHUTTER
PAT #CLOSE_SHUTTER    #CLOSE_SHUTTER  

PAT #STATE_0    #STATE_0
PAT #STATE_0A   #STATE_0A
PAT #STATE_1    #STATE_1
PAT #STATE_2    #STATE_2
PAT #STATE_3    #STATE_3
PAT #STATE_4    #STATE_4
PAT #STATE_5    #STATE_5
PAT #STATE_6    #STATE_6
PAT #STATE_7    #STATE_7
PAT #STATE_8    #STATE_8
PAT #STATE_8DG  #STATE_8DG
PAT #STATE_10RG #STATE_10RG
PAT #STATE_10OG #STATE_10OG
PAT #STATE_8A   #STATE_8A
PAT #STATE_8B   #STATE_8B
PAT #STATE_8C   #STATE_8C
PAT #STATE_8D   #STATE_8D
PAT #STATE_8E   #STATE_8E
PAT #STATE_9    #STATE_9
PAT #STATE_10   #STATE_10
PAT #STATE_10A  #STATE_10A
PAT #STATE_10B  #STATE_10B
PAT #STATE_10C  #STATE_10C
PAT #STATE_10D  #STATE_10D
PAT #STATE_10E  #STATE_10E
PAT #STATE_11   #STATE_11
PAT #STATE_12   #STATE_12
PAT #STATE_13   #STATE_13
PAT #STATE_14   #STATE_14
PAT #STATE_15   #STATE_15
PAT #STATE_16   #STATE_16
PAT #STATE_17   #STATE_17

*******************************************************
* All of the pattern words are the same for Type 2    *
* (front illuminated) as for Type 1 (back illuminated)*
* except for these 4 words.                           *
*******************************************************

PAT #R_STATE_3  #R_STATE_3
PAT #R_STATE_4  #R_STATE_4
PAT #R_STATE_6  #R_STATE_6
PAT #R_STATE_7  #R_STATE_7

*** TEMPORARY ***
PAT #STATE_VDD_LOW    #STATE_VDD_LOW
PAT #STATE_VDD_HIGH   #STATE_VDD_HIGH
PAT #STATE_VSUB_ON    #STATE_VSUB_ON
PAT #STATE_VSUB_OFF   #STATE_VSUB_OFF

PAT #ERASE_STATE_1    #ERASE_STATE_1       ** 39.000000 volts
PAT #ERASE_STATE_2    #ERASE_STATE_2       ** 38.000000 volts
PAT #ERASE_STATE_3    #ERASE_STATE_3       ** 37.000000 volts
PAT #ERASE_STATE_4    #ERASE_STATE_4       ** 36.000000 volts
PAT #ERASE_STATE_5    #ERASE_STATE_5       ** 35.000000 volts
PAT #ERASE_STATE_6    #ERASE_STATE_6       ** 34.000000 volts
PAT #ERASE_STATE_7    #ERASE_STATE_7       ** 33.000000 volts
PAT #ERASE_STATE_8    #ERASE_STATE_8       ** 32.000000 volts
PAT #ERASE_STATE_9    #ERASE_STATE_9       ** 31.000000 volts
PAT #ERASE_STATE_10   #ERASE_STATE_10      ** 30.000000 volts
PAT #ERASE_STATE_11   #ERASE_STATE_11      ** 29.000000 volts
PAT #ERASE_STATE_12   #ERASE_STATE_12      ** 28.000000 volts
PAT #ERASE_STATE_13   #ERASE_STATE_13      ** 27.000000 volts
PAT #ERASE_STATE_14   #ERASE_STATE_14      ** 26.000000 volts
PAT #ERASE_STATE_15   #ERASE_STATE_15      ** 25.000000 volts
PAT #ERASE_STATE_16   #ERASE_STATE_16      ** 24.000000 volts
PAT #ERASE_STATE_17   #ERASE_STATE_17      ** 23.000000 volts
PAT #ERASE_STATE_18   #ERASE_STATE_18      ** 22.000000 volts
PAT #ERASE_STATE_19   #ERASE_STATE_19      ** 21.000000 volts
PAT #ERASE_STATE_20   #ERASE_STATE_20      ** 20.000000 volts
PAT #ERASE_STATE_21   #ERASE_STATE_21      ** 19.000000 volts
PAT #ERASE_STATE_22   #ERASE_STATE_22      ** 18.000000 volts
PAT #ERASE_STATE_23   #ERASE_STATE_23      ** 17.000000 volts
PAT #ERASE_STATE_24   #ERASE_STATE_24      ** 16.000000 volts
PAT #ERASE_STATE_25   #ERASE_STATE_25      ** 15.000000 volts
PAT #ERASE_STATE_26   #ERASE_STATE_26      ** 14.000000 volts
PAT #ERASE_STATE_27   #ERASE_STATE_27      ** 13.000000 volts
PAT #ERASE_STATE_28   #ERASE_STATE_28      ** 12.000000 volts
PAT #ERASE_STATE_29   #ERASE_STATE_29      ** 11.000000 volts
PAT #ERASE_STATE_30   #ERASE_STATE_30      ** 10.000000 volts

PAT #ERASE_STATE_100  #ERASE_STATE_100
PAT #ERASE_STATE_101  #ERASE_STATE_101
PAT #ERASE_STATE_102  #ERASE_STATE_102
PAT #ERASE_STATE_103  #ERASE_STATE_103
PAT #ERASE_STATE_104  #ERASE_STATE_104
PAT #ERASE_STATE_105  #ERASE_STATE_105
PAT #ERASE_STATE_106  #ERASE_STATE_106
PAT #ERASE_STATE_107  #ERASE_STATE_107
PAT #ERASE_STATE_108  #ERASE_STATE_108
PAT #ERASE_STATE_109  #ERASE_STATE_109
PAT #ERASE_STATE_110  #ERASE_STATE_110
PAT #ERASE_STATE_111  #ERASE_STATE_111
PAT #ERASE_STATE_112  #ERASE_STATE_112
PAT #ERASE_STATE_113  #ERASE_STATE_113
PAT #ERASE_STATE_114  #ERASE_STATE_114
PAT #ERASE_STATE_115  #ERASE_STATE_115
PAT #ERASE_STATE_116  #ERASE_STATE_116
PAT #ERASE_STATE_117  #ERASE_STATE_117

PAT #ERASE_STATE_200   #ERASE_STATE_200      ** 9.000000 volts
PAT #ERASE_STATE_201   #ERASE_STATE_201      ** 8.000000 volts
PAT #ERASE_STATE_202   #ERASE_STATE_202      ** 7.000000 volts
PAT #ERASE_STATE_203   #ERASE_STATE_203      ** 6.000000 volts
PAT #ERASE_STATE_204   #ERASE_STATE_204      ** 5.000000 volts
PAT #ERASE_STATE_205   #ERASE_STATE_205      ** 4.000000 volts
PAT #ERASE_STATE_206   #ERASE_STATE_206      ** 3.000000 volts
PAT #ERASE_STATE_207   #ERASE_STATE_207      ** 2.000000 volts
PAT #ERASE_STATE_208   #ERASE_STATE_208      ** 1.000000 volts
PAT #ERASE_STATE_209   #ERASE_STATE_209      ** 0.000000 volts

PAT #ERASE_STATE_300   #ERASE_STATE_300      ** 1.000000 volts
PAT #ERASE_STATE_301   #ERASE_STATE_301      ** 2.000000 volts
PAT #ERASE_STATE_302   #ERASE_STATE_302      ** 3.000000 volts
PAT #ERASE_STATE_303   #ERASE_STATE_303      ** 4.000000 volts
PAT #ERASE_STATE_304   #ERASE_STATE_304      ** 5.000000 volts
PAT #ERASE_STATE_305   #ERASE_STATE_305      ** 6.000000 volts
PAT #ERASE_STATE_306   #ERASE_STATE_306      ** 7.000000 volts
PAT #ERASE_STATE_307   #ERASE_STATE_307      ** 8.000000 volts
PAT #ERASE_STATE_308   #ERASE_STATE_308      ** 9.000000 volts
PAT #ERASE_STATE_309   #ERASE_STATE_309      ** 10.000000 volts

PAT #ERASE_STATE_350  #ERASE_STATE_350
PAT #ERASE_STATE_351  #ERASE_STATE_351
PAT #ERASE_STATE_352  #ERASE_STATE_352
PAT #ERASE_STATE_353  #ERASE_STATE_353
PAT #ERASE_STATE_354  #ERASE_STATE_354
PAT #ERASE_STATE_355  #ERASE_STATE_355
PAT #ERASE_STATE_356  #ERASE_STATE_356
PAT #ERASE_STATE_357  #ERASE_STATE_357
PAT #ERASE_STATE_358  #ERASE_STATE_358
PAT #ERASE_STATE_359  #ERASE_STATE_359
PAT #ERASE_STATE_360  #ERASE_STATE_360
PAT #ERASE_STATE_361  #ERASE_STATE_361
PAT #ERASE_STATE_362  #ERASE_STATE_362
PAT #ERASE_STATE_363  #ERASE_STATE_363
PAT #ERASE_STATE_364  #ERASE_STATE_364
PAT #ERASE_STATE_365  #ERASE_STATE_365
PAT #ERASE_STATE_366  #ERASE_STATE_366
PAT #ERASE_STATE_367  #ERASE_STATE_367

PAT #ERASE_STATE_400   #ERASE_STATE_400      ** 11.000000 volts
PAT #ERASE_STATE_401   #ERASE_STATE_401      ** 12.000000 volts
PAT #ERASE_STATE_402   #ERASE_STATE_402      ** 13.000000 volts
PAT #ERASE_STATE_403   #ERASE_STATE_403      ** 14.000000 volts
PAT #ERASE_STATE_404   #ERASE_STATE_404      ** 15.000000 volts
PAT #ERASE_STATE_405   #ERASE_STATE_405      ** 16.000000 volts
PAT #ERASE_STATE_406   #ERASE_STATE_406      ** 17.000000 volts
PAT #ERASE_STATE_407   #ERASE_STATE_407      ** 18.000000 volts
PAT #ERASE_STATE_408   #ERASE_STATE_408      ** 19.000000 volts
PAT #ERASE_STATE_409   #ERASE_STATE_409      ** 20.000000 volts
PAT #ERASE_STATE_410   #ERASE_STATE_410      ** 21.000000 volts
PAT #ERASE_STATE_411   #ERASE_STATE_411      ** 22.000000 volts
PAT #ERASE_STATE_412   #ERASE_STATE_412      ** 23.000000 volts
PAT #ERASE_STATE_413   #ERASE_STATE_413      ** 24.000000 volts
PAT #ERASE_STATE_414   #ERASE_STATE_414      ** 25.000000 volts
PAT #ERASE_STATE_415   #ERASE_STATE_415      ** 26.000000 volts
PAT #ERASE_STATE_416   #ERASE_STATE_416      ** 27.000000 volts
PAT #ERASE_STATE_417   #ERASE_STATE_417      ** 28.000000 volts
PAT #ERASE_STATE_418   #ERASE_STATE_418      ** 29.000000 volts
PAT #ERASE_STATE_419   #ERASE_STATE_419      ** 30.000000 volts
PAT #ERASE_STATE_420   #ERASE_STATE_420      ** 31.000000 volts
PAT #ERASE_STATE_421   #ERASE_STATE_421      ** 32.000000 volts
PAT #ERASE_STATE_422   #ERASE_STATE_422      ** 33.000000 volts
PAT #ERASE_STATE_423   #ERASE_STATE_423      ** 34.000000 volts
PAT #ERASE_STATE_424   #ERASE_STATE_424      ** 35.000000 volts
PAT #ERASE_STATE_425   #ERASE_STATE_425      ** 36.000000 volts
PAT #ERASE_STATE_426   #ERASE_STATE_426      ** 37.000000 volts
PAT #ERASE_STATE_427   #ERASE_STATE_427      ** 38.000000 volts
PAT #ERASE_STATE_428   #ERASE_STATE_428      ** 39.000000 volts
PAT #ERASE_STATE_429   #ERASE_STATE_429      ** 40.000000 volts


*************************************
* PROGRAM CODE SEGMENT STARTS HERE **
*************************************
** EXECUTIVE ROUTINE
#MAIN   DMS 200                   * Allow the PAN to finish with sequencer bus
#NEXT   CAL #INIT

        LMR #WRITE32              * NEW: DHE Master initial condition
	LPP #SET_SYNC_HIGH        * NEW: Set SYNC high
	LSR #MCB                  * NEW:   as DHE Master initial condition

#EXEC   JCB #GOBABY #START        * Wait for START EXPOSURE flag
        JMP #EXEC                 *

#GOBABY LMR #WRITE32              * Set 32-bit write mode
***************************
*       move sync into SYC subroutine. do not call for clear and erase
*	LPP #SET_SYNC_LOW
*	LSR #MCB
*
*#WAIT   JCB #WAIT #SYNC
*	NOP
*
*	LPP #SET_SYNC_HIGH        * NEW: Reset Sync bit high
*	LSR #MCB                  * NEW:
***************************
	JCB #TYPE2 #VCTR_8
        JCB #CASE_1 #VCTR_1       * Do Read Function - CCD Type 1
	JCB #CASE_2 #VCTR_2       * Do Clear Function - CCD Type 1
	JCB #CASE_3 #VCTR_3       * Do Erase Function - CCD Type 1
	JCB #CASE_4 #VCTR_4       * Do Expose/Read Function - CCD Type 1
	JCB #CASE_5 #VCTR_5       * Do Expose/Read/Erase/Clear - CCD Type 1
	JCB #CASE_6 #VCTR_6       * Do Shift Function - CCD Type 1

        JMP #EXEC
#TYPE2	JCB #CASE_7 #VCTR_1       * Do Read Function - CCD Type 2
	JCB #CASE_8 #VCTR_2       * Do Clear Function - CCD Type 2
	JCB #CASE_9 #VCTR_3       * Do Erase Function - CCD Type 2
	JCB #CASE_10 #VCTR_4      * Do Expose/Read Function - CCD Type 2
	JCB #CASE_11 #VCTR_5      * Do Expose/Read/Erase/Clear - CCD Type 2
	JCB #CASE_12 #VCTR_6      * Do Shift Function - CCD Type 2

	JMP #EXEC

#CASE_1 CAL #KILLFLAG
	CAL #SYNC
	*CAL #KILLFLAG
        CAL #READTYPE1
	JMP #NEXT

#CASE_2 NOP
	JCB #CASE_23 #VCTR_3      * Do Erase & CLEAR Function - CCD Type 1
	CAL #CLEAR_BIN_TYPE1      * Only vertical clocks produced; no data
        CAL #KILLFLAG
        JMP #NEXT

#CASE_23 CAL #ERASE                * Manipulate VSUB, H_CLKs to erase CCD
	CAL #CLEAR_BIN_TYPE1      * Only vertical clocks produced; no data
        CAL #KILLFLAG
        JMP #NEXT
	
#CASE_3 CAL #ERASE                * Manipulate VSUB, H_CLKs to erase CCD
        CAL #KILLFLAG
	JMP #NEXT

#CASE_4 CAL #KILLFLAG
	CAL #SYNC
	*CAL #KILLFLAG
        CAL #EXPOSE
        CAL #READTYPE1
        JMP #NEXT
	
#CASE_5 CAL #KILLFLAG
	CAL #SYNC
	*CAL #KILLFLAG
        CAL #EXPOSE
	CAL #READTYPE1
	CAL #ERASE
	CAL #CLEAR_BIN_TYPE1
	JMP #NEXT

#CASE_6	CAL #SHIFTLINES_TYPE1   * do we need SYNC ? 
	CAL #KILLFLAG
	JMP #NEXT
	
#CASE_7 CAL #KILLFLAG
	CAL #SYNC
	*CAL #KILLFLAG
        CAL #READTYPE2
	JMP #NEXT

#CASE_8 NOP
	JCB #CASE_89 #VCTR_3       * Do Erase & CLEAR Function - CCD Type 2
	CAL #CLEAR_BIN_TYPE2      * Only vertical clocks produced; no data\
        CAL #KILLFLAG
        JMP #NEXT
	
#CASE_89 CAL #ERASE                * Manipulate VSUB, H_CLKs to erase CCD
	CAL #CLEAR_BIN_TYPE2      * Only vertical clocks produced; no data\
        CAL #KILLFLAG
	JMP #NEXT
	
#CASE_9 CAL #ERASE                * Manipulate VSUB, H_CLKs to erase CCD
        CAL #KILLFLAG
	JMP #NEXT

#CASE_10 CAL #KILLFLAG
	CAL #SYNC
	*CAL #KILLFLAG
        CAL #EXPOSE
        CAL #READTYPE2
        JMP #NEXT
	
#CASE_11 CAL #KILLFLAG
	CAL #SYNC
	*CAL #KILLFLAG
        CAL #EXPOSE
	CAL #READTYPE2
	CAL #ERASE
	CAL #CLEAR_BIN_TYPE2
	JMP #NEXT
	
#CASE_12 CAL #SHIFTLINES_TYPE2     * do we need SYNC ?
	CAL #KILLFLAG
	JMP #NEXT
	
*********************************************
* INITIALIZATION BEFORE START_EXPOSURE FLAG *
*********************************************

#INIT    LMR #WRITE32             * SET 32 BIT WRITE MODE
         DUS #DELAY_20us
         ***** [STATE_0]
         LDA #CLKPORT
         LPP #STATE_0
         LSR #CCDCLK              * Write to CBB board
         ***** [STATE_0A]
         LPP #STATE_0A
         LDA #CDSREG
         LSR #CCDACQ              * Write to Video board
         RET

************
* SYNCING  *
************
#SYNC	LMR #WRITE32              * set 32 bit write mode 
	LPP #SET_SYNC_LOW         * NEW: Set Sync low. Nothing happend till
	LSR #MCB                  * NEW:   the delay has completed
#WAIT   JCB #WAIT #SYNC           * NEW: Sync goes false synchronously on all
                                  * NEW:   dhes after delay
	NOP
	LPP #SET_SYNC_HIGH        * NEW: Reset Sync bit high
	LSR #MCB                  * NEW:
	RET

	
*********************************************
* Write pulse to VDD                        *
*********************************************
#MARK_ZERO DUS 1
         LMR #WRITE16
	 DUS 1
	 LDA #DEVICE0
	 DUS 1
	 LPP #STATE_VDD_LOW
	 DUS 1
	 LSR #CCDACQ
	 RET

#MARK	 DUS 1
         LMR #WRITE16
	 DUS 1
	 LDA #DEVICE0
	 DUS 1
	 LPP #STATE_VDD_HIGH
	 DUS 1
	 LSR #CCDACQ              * Set VDD High
	 DMS 5
	 LPP #STATE_VDD_LOW
	 DUS 1
	 LSR #CCDACQ
	 RET
	 
#TOGGLE_ALL_CLKS  DUS 1
         LMR #WRITE32
	 DUS 1
	 LPP #ALL_CLKS_LOW
         LSR #CCDCLK
	 DMS 25
	 LPP #ALL_CLKS_HIGH
	 LSR #CCDCLK
	 DMS 25
	 LPP #ALL_CLKS_LOW
	 LSR #CCDCLK
	 DMS 25
	 LMR #WRITE16
	 RET

#VSUBDELAY1   DMS #DELAY_256ms   * DELAY: 1.5 s
	 DMS #DELAY_256ms
	 DMS #DELAY_256ms
	 DMS #DELAY_256ms
	 DMS #DELAY_256ms
	 DMS #DELAY_256ms
	 RET

#VSUBDELAY2 DMS #DELAY_256ms      * DELAY: 0.375s
         DMS #DELAY_119ms
	 RET

*********************************************
* ERASE START_EXPOSURE FLAG                 *
*********************************************
#KILLFLAG  LPP #KILL_EXPFLG       * Kill the 'START EXPOSURE' flag
        LMR #WRITE32              * by setting 32 bit write mode
        LSR #MCB                  * and writing to the EFR
        RET

*********************************************
* ERASE CCD FUNCTION                        *
*********************************************
*****           a) Ramp VSUB to 10V
*****           b) Set  VCLK DACs to 8V
*****           c) Ramp VSUB to 0V
*****           d) Wait
*****           e) Ramp VSUB to 10V
*****           f) Set  VCLK DACs to +6.5/-1.5 V
*****           g) Ramp VSUB to 40V

#ERASE   LMR #WRITE16
         LDA #DEVICE0             * Use DEVICE ADDR = 0

	 CAL #RAMP_40_TO_10       * VSUB RAMPS TO 10V
	 CAL #SET_VCLK_TO_8V
	 CAL #RAMP_10_TO_0        * VSUB RAMPS TO 0V

         LRB #ERASE_TIME          * DELAY = n x 10 ms
	 DMS 10
	 LPE

	 CAL #RAMP_0_TO_10        * VSUB RAMPS TO 10V	 
	 CAL #RESTORE_VCLK 
	 CAL #RAMP_10_TO_40       * VSUB RAMPS TO 40V
	 
	 LMR #WRITE32             * RESTORE TRANSFER MODE

	 RET
	
* Version of Erase that uses hardware VSUB ramp circuit (2.4 seconds)	 
#ERASE2  LMR #WRITE16
         LDA #DEVICE0             * Use DEVICE ADDR = 0

	 CAL #DISABLE_VSUB        * VSUB RAMPS TO 0V
	 CAL #ERASE_D1            * 320 MS
	 CAL #SET_VCLK_TO_8V
	 CAL #ERASE_D2            * 560 MS
	 CAL #RESTORE_VCLK
	 CAL #ERASE_D3            * 320 MS
	 CAL #ENABLE_VSUB         * VSUB RAMPS TO 40V
         CAL #ERASE_D4            * 1120 MS
	 
	 LMR #WRITE32             * RESTORE TRANSFER MODE

	 RET
	
#DISABLE_VSUB LPP #STATE_VSUB_OFF
          LSR #CCDACQ
	  RET
	  
#ENABLE_VSUB LPP #STATE_VSUB_ON
          LSR #CCDACQ
	  RET
	 
#ERASE_D1 DMS #DELAY_256ms
          DMS #DELAY_64ms
	  RET	 
	
#ERASE_D2 DMS #DELAY_256ms
          DMS #DELAY_256ms
	  DMS #DELAY_60ms
	  RET
	  
#ERASE_D3 DMS #DELAY_256ms
          DMS #DELAY_64ms
	  RET
	  
#ERASE_D4 DMS #DELAY_256ms
          DMS #DELAY_256ms
	  DMS #DELAY_256ms
	  DMS #DELAY_256ms
	  DMS #DELAY_120ms
	  RET 	 
	 
*********************************************
* RAMP VSUB FROM 40 -> 10V                  *
*********************************************
#RAMP_40_TO_10    LPP #ERASE_STATE_1      ** 39.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_2               ** 38.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_3               ** 37.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_4               ** 36.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_5               ** 35.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_6               ** 34.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_7               ** 33.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_8               ** 32.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_9               ** 31.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_10              ** 30.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_11              ** 29.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_12              ** 28.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_13              ** 27.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_14              ** 26.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_15              ** 25.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_16              ** 24.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_17              ** 23.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_18              ** 22.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_19              ** 21.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_20              ** 20.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_21              ** 19.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_22              ** 18.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_23              ** 17.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_24              ** 16.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_25              ** 15.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_26              ** 14.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_27              ** 13.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_28              ** 12.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_29              ** 11.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_30              ** 10.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE

         RET

*********************************************
* RAMP VSUB FROM 10 -> 0V                   *
*********************************************
#RAMP_10_TO_0      LPP #ERASE_STATE_200     ** 9.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_201               ** 8.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_202               ** 7.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_203               ** 6.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_204               ** 5.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_205               ** 4.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_206               ** 3.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_207               ** 2.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_208               ** 1.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_209               ** 0.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE

         RET

*********************************************
* RAMP VSUB FROM 0 -> 10V                   *
*********************************************
#RAMP_0_TO_10      LPP #ERASE_STATE_300     ** 1.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_301               ** 2.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_302               ** 3.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_303               ** 4.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_304               ** 5.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_305               ** 6.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_306               ** 7.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_307               ** 8.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_308               ** 9.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_309               ** 10.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE

         RET

*********************************************
* RAMP VSUB FROM 10 -> 40V                  *
*********************************************
#RAMP_10_TO_40           LPP #ERASE_STATE_400               ** 11.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_401               ** 12.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_402               ** 13.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_403               ** 14.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_404               ** 15.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_405               ** 16.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_406               ** 17.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_407               ** 18.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_408               ** 19.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_409               ** 20.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_410               ** 21.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_411               ** 22.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_412               ** 23.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_413               ** 24.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_414               ** 25.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_415               ** 26.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_416               ** 27.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_417               ** 28.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_418               ** 29.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_419               ** 30.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_420               ** 31.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_421               ** 32.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_422               ** 33.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_423               ** 34.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_424               ** 35.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_425               ** 36.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_426               ** 37.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_427               ** 38.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_428               ** 39.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
         LPP #ERASE_STATE_429               ** 40.000000 volts
         LSR #CCDACQ
         DMS #SLEW_RATE
	 
	 RET


*********************************************
* TURN V CLKS TO 8V                         *
*********************************************
#SET_VCLK_TO_8V         LPP #ERASE_STATE_100
         LSR #CCDCLK              * 8V => A_V1_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_101
         LSR #CCDCLK              * 8V => A_V1_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_102
         LSR #CCDCLK              * 8V => A_V2_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_103
         LSR #CCDCLK              * 8V => A_V2_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_104
         LSR #CCDCLK              * 8V => A_V3_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_105
         LSR #CCDCLK              * 8V => A_V3_LOW
         DUS #DAC_DELAY

         LPP #ERASE_STATE_106
         LSR #CCDCLK              * 8V => B_V1_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_107
         LSR #CCDCLK              * 8V => B_V1_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_108
         LSR #CCDCLK              * 8V => B_V2_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_109
         LSR #CCDCLK              * 8V => B_V2_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_110
         LSR #CCDCLK              * 8V => B_V3_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_111
         LSR #CCDCLK              * 8V => B_V3_LOW
         DUS #DAC_DELAY

         LPP #ERASE_STATE_112
         LSR #CCDCLK              * 8V => C_V1_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_113
         LSR #CCDCLK              * 8V => C_V1_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_114
         LSR #CCDCLK              * 8V => C_V2_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_115
         LSR #CCDCLK              * 8V => C_V2_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_116
         LSR #CCDCLK              * 8V => C_V3_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_117
         LSR #CCDCLK              * 8V => C_V3_LOW
         DUS #DAC_DELAY

         RET

*********************************************
* TURN V CLKS TO 8V                         *
*********************************************

#RESTORE_VCLK     LPP #ERASE_STATE_350
         LSR #CCDCLK              * 6.5V  => A_V1_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_351
         LSR #CCDCLK              * 6.5V  => A_V2_HIGH
         DUS #DAC_DELAY
         LPP #ERASE_STATE_352
         LSR #CCDCLK              * 6.5V  => A_V3_HIGH
         DUS #DAC_DELAY
         LPP #ERASE_STATE_353
         LSR #CCDCLK              * -1.5V => A_V1_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_354
         LSR #CCDCLK              * -1.5V => A_V2_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_355
         LSR #CCDCLK              * -1.5V => A_V3_LOW
         DUS #DAC_DELAY

         LPP #ERASE_STATE_356
         LSR #CCDCLK              * 6.5V  => B_V1_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_357
         LSR #CCDCLK              * 6.5V  => B_V2_HIGH
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_358
         LSR #CCDCLK              * 6.5V  => B_V3_HIGH
         DUS #DAC_DELAY
         LPP #ERASE_STATE_359
         LSR #CCDCLK              * -1.5V => B_V1_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_360
         LSR #CCDCLK              * -1.5V => B_V2_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_361
         LSR #CCDCLK              * -1.5V => B_V3_LOW
         DUS #DAC_DELAY

         LPP #ERASE_STATE_362
         LSR #CCDCLK              * 6.5V  => C_V1_HIGH
         DUS #DAC_DELAY
         LPP #ERASE_STATE_363
         LSR #CCDCLK              * 6.5V  => C_V2_HIGH
	 DUS #DAC_DELAY
	 LPP #ERASE_STATE_364
	 LSR #CCDCLK              * 6.5v  => C_V3_HIGH
         DUS #DAC_DELAY
         LPP #ERASE_STATE_365	 
         LSR #CCDCLK              * -1.5V => C_V1_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_366
         LSR #CCDCLK              * -1.5V => C_V2_LOW
         DUS #DAC_DELAY
	 LPP #ERASE_STATE_367
         LSR #CCDCLK              * -1.5V => C_V3_LOW
         DUS #DAC_DELAY

         RET


*********************************************
* CLEAR CCD FUNCTION                        *
*********************************************
#CLEAR_BIN_TYPE1 DUS #DELAY_20us      * DELAY 20 us 
         LRB #ROWS_CLEAR                * BEGIN LOOP( DET_ROWS/ROWBINCLR)
           LRB #ROWBIN_CLEAR
	     CAL #PAR_SGL_SHFT
           LPE
	   LRB #COLS
 	    CAL #SER_SGL_SHFT_TYPE1
	   LPE
	 LPE	
	RET	

#CLEAR_BIN_TYPE2 DUS #DELAY_20us      * DELAY 20 us 
         LRB #ROWS_CLEAR                * BEGIN LOOP( ROWS/ROWBINCLR)
           LRB #ROWBIN_CLEAR
	     CAL #PAR_SGL_SHFT
           LPE
	   LRB #COLS
 	    CAL #SER_SGL_SHFT_TYPE2
	   LPE
	 LPE
	RET
	
#PAR_SGL_SHFT DUS #DELAY_1us      * DELAY 1 us
	 LDA #CLKPORT             *     SET UP CLK OUTPUT PORT 
	 ***** [STATE_11]         *   Tg -> LOW
         LPP #STATE_11
         DUS #DELAY_1us
         LDA #CLKPORT             *   REGISTER = CLKPORT
         LSR #CCDCLK              *   Write to CBB Board
	 LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_12]         *   V3 -> LOW 
         LPP #STATE_12
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_13]         *   V2 -> HIGH
         LPP #STATE_13
         LSR #CCDCLK              *   Write to CBB Board 
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_14]         *   V2 -> LOW 
         LPP #STATE_14
         LSR #CCDCLK              *   Write to CBB Board 
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_15]         *   V3 -> HIGH
         LPP #STATE_15
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_16]         *   V2 -> LOW; Tg -> HIGH 
         LPP #STATE_16
         LSR #CCDCLK              *   Write to CBB Board 
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** 
         RET

	
*****************************************************
* shift all pixels in one Row                       * 
* PERFORM ALL CCD CLOCKS ONLY - NO ADC DATA         *
*****************************************************
#SER_SGL_SHFT_TYPE1 DUS #DELAY_1us      * DELAY 1 us
	 LDA #CLKPORT             *     SET UP CLK OUTPUT PORT 
         ***** [STATE_3]          *     H1 -> LOW
	 LPP #STATE_3
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_4]          *     H2 -> HIGH 
	 LPP #STATE_4
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_5]          *     H3 -> LOW
	 LPP #STATE_5     
         LSR #CCDCLK              *     Write to CBB Board		
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_6]          *     H1 -> HIGH 
	 LPP #STATE_6
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK 
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_7]          *     H2 -> LOW 
         LPP #STATE_7
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8]          *     H3 -> HIGH 
         LPP #STATE_8
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
	 LPE
         ***** [STATE_9]          *     SW -> HIGH
         LPP #STATE_9
         LDA #CLKPORT             *     REGISTER = CLKPORT
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK 
         LRB #SW_WIDTH
         LPE
         ***** [STATE_10]         *     SW -> LOW
         LPP #STATE_10
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_SW             *     DELAY = n x 100n
	 LPE

         RET

#SER_SGL_SHFT_TYPE2 DUS #DELAY_1us      * DELAY 1 us
	 LDA #CLKPORT             *     SET UP CLK OUTPUT PORT 
        ***** [STATE_3]          *     H1 -> LOW
	 LPP #R_STATE_3
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_4]          *     H2 -> HIGH 
	 LPP #R_STATE_4
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_5]          *     H3 -> LOW
	 LPP #STATE_5     
         LSR #CCDCLK              *     Write to CBB Board		
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_6]          *     H1 -> HIGH 
	 LPP #R_STATE_6
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK 
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_7]          *     H2 -> LOW 
         LPP #R_STATE_7
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8]          *     H3 -> HIGH 
         LPP #STATE_8
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
	 LPE
         ***** [STATE_9]          *     SW -> HIGH
         LPP #STATE_9
         LDA #CLKPORT             *     REGISTER = CLKPORT
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK 
         LRB #SW_WIDTH
         LPE
         ***** [STATE_10]         *     SW -> LOW
         LPP #STATE_10
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_SW             *     DELAY = n x 100n
	 LPE
	
	 RET	


*****************************************************
* PERFORM ALL CCD CLOCKS, DOUBLE SLOPED INTEGRATION *
* AND CONVERTIONS                                   *
*****************************************************
#DUMMYREAD  DUS #DELAY_20us       * DELAY 20 us
         LRB #ROWS                * BEGIN LOOP( ROWS)
         LRB #COLS                *   BEGIN LOOP( COLS)
	 LDA #CLKPORT             *     SET UP CLK OUTPUT PORT
	 
         ***** [STATE_8A]         *     CDS_RST -> LOW; CDS_DCR -> LOW
	 LPP #STATE_8A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
	 
         ***** [STATE_8B]         *     CDS_INT -> HIGH
	 LPP #STATE_8B
         LSR #CCDACQ              *     Write to Video Board
         LRB #INTEG_WIDTH         *     DELAY = n x 100ns
	 LPE
	 
         ***** [STATE_8C]         *     CDS_INT -> LOW
	 LPP #STATE_8C
         LSR #CCDACQ              *     Write to Video Board
	 
         ***** [STATE_8D]         *     CDS_NIN -> LOW
         LPP #STATE_8D            *     (Make NIN before break INV.)
         LSR #CCDACQ              *     WRITE TO Video Board
	 
         ***** [STATE_8E]         *     CDS_INV -> HIGH
         LPP #STATE_8E
         LSR #CCDACQ	 
	 
         ***** [STATE_10A]        *     CDS_INT -> HIGH
         LPP #STATE_10A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         LRB #INTEG_WIDTH         *     DELAY = n x 100 ns
	 LPE
	 
         ***** [STATE_10B]        *     CDS_INT -> LOW
         LPP #STATE_10B
	 LSR #CCDACQ              *     Write to Video Board

         ***** [STATE_10C]        *     CDS_CTC -> HIGH
         LPP #STATE_10C
	 LSR #CCDACQ              *     Write to Video Board

         ***** [STATE_10D]        *     CDS_CTC -> LOW
         LPP #STATE_10D
	 LSR #CCDACQ              *     Write to Video Board
	 
	 ***** [STATE 10E]        *     Restore CDS_RST,CDS_DCR,CDS_NIN,CDS_INV
	 LPP #STATE_10E
	 LSR #CCDACQ              *     Write to Video Board
	 
	 ***** [END LOOP]
         LPE                      *   END LOOP
	                       
	 ***** [END LOOP]	 
         LPE                      * END LOOP
         RET
	 
#SHIFTLINES_TYPE1   DUS #DELAY_20us       * DELAY 20 us
         LRB #SHIFT_ROWS                * BEGIN LOOP( ROWS)
         LRB #COLS                *   BEGIN LOOP( COLS)
	 LDA #CLKPORT             *     SET UP CLK OUTPUT PORT
         ***** [STATE_1]          *     Rg -> LOW
    *     LPP #STATE_1             *     INITIAL STATE
    *     LSR #CCDCLK              *     Write to CBB Board
    *     LRB #RG_WIDTH            *     DELAY = n x 100ns
    *  	  LPE
    *	  ***** [STATE_2]          *     Rg -> HIGH
    *	  LPP #STATE_2
    *	  LSR #CCDCLK              *     Write to CBB Board
    *     LRB #POST_RG             *     DELAY = n x 100ns
    *	  LPE
         ***** [STATE_3]          *     H1 -> LOW
	 LPP #STATE_3
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_4]          *     H2 -> HIGH
	 LPP #STATE_4
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_5]          *     H3 -> LOW
	 LPP #STATE_5
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_6]          *     H1 -> HIGH
	 LPP #STATE_6
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_7]          *     H2 -> LOW
         LPP #STATE_7
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8]          *     H3 -> HIGH
         LPP #STATE_8
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8A]         *     CDS_RST -> LOW; CDS_DCR -> LOW
	 LPP #STATE_8A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_8B]         *     CDS_INT -> HIGH
	 LPP #STATE_8B
         LSR #CCDACQ              *     Write to Video Board
         **LRB #INTEG_WIDTH         *     DELAY = n x 100ns --> omit in SHIFTLINES <---
	 **LPE
         ***** [STATE_8C]         *     CDS_INT -> LOW
	 LPP #STATE_8C
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_8D]         *     CDS_NIN -> LOW
         LPP #STATE_8D            *     (Make NIN before break INV.)
         LSR #CCDACQ              *     WRITE TO Video Board
         ***** [STATE_8E]         *     CDS_INV -> HIGH
         LPP #STATE_8E
         LSR #CCDACQ
         *LRB #PRE_SW
         *LPE
         ***** [STATE_9]          *     SW -> HIGH
         LPP #STATE_9
         LDA #CLKPORT             *     REGISTER = CLKPORT
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #SW_WIDTH
         LPE
         ***** [STATE_10]         *     SW -> LOW
*         LPP #STATE_10
*         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
*         *LRB #POST_SW             *     DELAY = n x 100n
*	 *LPE
         ***** [STATE_10A]        *     CDS_INT -> HIGH
         LPP #STATE_10A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         **LRB #INTEG_WIDTH         *     DELAY = n x 100 ns   --> omit in SHIFTLINES <---
	 **LPE
         ***** [STATE_10B]        *     CDS_INT -> LOW
         LPP #STATE_10B
	 LSR #CCDACQ              *     Write to Video Board
         *LRB #PRE_CTC             *     DELAY = n x 100ns
	 *LPE
         ***** [STATE_10C]        *     CDS_CTC -> HIGH  NO DIGITIZATION IN SHIFTLINES <--
         **LPP #STATE_10C
	 **LSR #CCDACQ            *     Write to Video Board
         *DSC #DELAY_100ns        *     DELAY 100 ns
         ***** [STATE_10D]        *     CDS_CTC -> LOW
         LPP #STATE_10D
	 LSR #CCDACQ              *     Write to Video Board
         *LRB #POST_CTC            *     DELAY = n x 100ns
	 *LPE
	 ***** [STATE 10E]        *     Restore CDS_RST,CDS_DCR,CDS_NIN,CDS_INV
	 LPP #STATE_10E
	 LSR #CCDACQ              *     Write to Video Board
	 ***** [END LOOP]
         LPE                      *   END LOOP
         ***** [STATE_11]         *   Tg -> LOW
         LPP #STATE_11
         DUS #DAC_DELAY
         LDA #CLKPORT             *   REGISTER = CLKPORT
         LSR #CCDCLK              *   Write to CBB Board
	 LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_12]         *   V3 -> LOW
         LPP #STATE_12
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_13]         *   V2 -> HIGH
         LPP #STATE_13
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_14]         *   V2 -> LOW
         LPP #STATE_14
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_15]         *   V3 -> HIGH
         LPP #STATE_15
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_16]         *   V2 -> LOW; Tg -> HIGH
         LPP #STATE_16
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE

         *****
         LPE                      * END LOOP
         RET

#SHIFTLINES_TYPE2 DUS #DELAY_20us       * DELAY 20 us
         LRB #SHIFT_ROWS              * BEGIN LOOP( ROWS)
         LRB #COLS                *   BEGIN LOOP( COLS)
	 LDA #CLKPORT             *     SET UP CLK OUTPUT PORT
         ***** [STATE_1]          *     Rg -> LOW
    *     LPP #STATE_1             *     INITIAL STATE
    *     LSR #CCDCLK              *     Write to CBB Board
    *     LRB #RG_WIDTH            *     DELAY = n x 100ns
    *  	  LPE
    *	  ***** [STATE_2]          *     Rg -> HIGH
    *	  LPP #STATE_2
    *	  LSR #CCDCLK              *     Write to CBB Board
    *     LRB #POST_RG             *     DELAY = n x 100ns
    *	  LPE
         ***** [STATE_3]          *     H1 -> LOW
	 LPP #R_STATE_3
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_4]          *     H2 -> HIGH
	 LPP #R_STATE_4
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_5]          *     H3 -> LOW
	 LPP #STATE_5
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_6]          *     H1 -> HIGH
	 LPP #R_STATE_6
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_7]          *     H2 -> LOW
         LPP #R_STATE_7
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8]          *     H3 -> HIGH
         LPP #STATE_8
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8A]         *     CDS_RST -> LOW; CDS_DCR -> LOW
	 LPP #STATE_8A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_8B]         *     CDS_INT -> HIGH
	 LPP #STATE_8B
         LSR #CCDACQ              *     Write to Video Board
         **LRB #INTEG_WIDTH         *     DELAY = n x 100ns   --> omit in SHIFTLINES <---
	 **LPE
         ***** [STATE_8C]         *     CDS_INT -> LOW
	 LPP #STATE_8C
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_8D]         *     CDS_NIN -> LOW
         LPP #STATE_8D            *     (Make NIN before break INV.)
         LSR #CCDACQ              *     WRITE TO Video Board
         ***** [STATE_8E]         *     CDS_INV -> HIGH
         LPP #STATE_8E
         LSR #CCDACQ
         *LRB #PRE_SW
         *LPE
         ***** [STATE_9]          *     SW -> HIGH
         LPP #STATE_9
         LDA #CLKPORT             *     REGISTER = CLKPORT
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #SW_WIDTH
         LPE
         ***** [STATE_10]         *     SW -> LOW
*         LPP #STATE_10
*         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
*         *LRB #POST_SW             *     DELAY = n x 100n
*	 *LPE
         ***** [STATE_10A]        *     CDS_INT -> HIGH
         LPP #STATE_10A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         **LRB #INTEG_WIDTH         *     DELAY = n x 100 ns  --> omit in SHIFTLINES <---
	 **LPE
         ***** [STATE_10B]        *     CDS_INT -> LOW
         LPP #STATE_10B
	 LSR #CCDACQ              *     Write to Video Board
         *LRB #PRE_CTC             *     DELAY = n x 100ns
	 *LPE
         ***** [STATE_10C]        *     CDS_CTC -> HIGH   --> NO DIGITIZATION IN SHIFTLINES <---
         **LPP #STATE_10C
	 **LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_10D]        *     CDS_CTC -> LOW
         LPP #STATE_10D
	 LSR #CCDACQ              *     Write to Video Board
         *LRB #POST_CTC            *     DELAY = n x 100ns
	 *LPE
	 ***** [STATE 10E]        *     Restore CDS_RST,CDS_DCR,CDS_NIN,CDS_INV
	 LPP #STATE_10E
	 LSR #CCDACQ              *     Write to Video Board
	 ***** [END LOOP]
         LPE                      *   END LOOP
         ***** [STATE_11]         *   Tg -> LOW
         LPP #STATE_11
         DUS #DAC_DELAY
         LDA #CLKPORT             *   REGISTER = CLKPORT
         LSR #CCDCLK              *   Write to CBB Board
	 LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_12]         *   V3 -> LOW
         LPP #STATE_12
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_13]         *   V2 -> HIGH
         LPP #STATE_13
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_14]         *   V2 -> LOW
         LPP #STATE_14
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_15]         *   V3 -> HIGH
         LPP #STATE_15
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_16]         *   V2 -> LOW; Tg -> HIGH
         LPP #STATE_16
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE

         *****
         LPE                      * END LOOP
         RET
	
#########################################################	
#READTYPE1  DUS #DELAY_20us       * DELAY 20 us
         LRB #ROWS                * BEGIN LOOP( ROWS)
         LRB #COLS                *   BEGIN LOOP( COLS)
	 LDA #CLKPORT             *     SET UP CLK OUTPUT PORT
         ***** [STATE_1]          *     Rg -> LOW
    *     LPP #STATE_1             *     INITIAL STATE
    *     LSR #CCDCLK              *     Write to CBB Board
    *     LRB #RG_WIDTH            *     DELAY = n x 100ns
    *  	  LPE
    *	  ***** [STATE_2]          *     Rg -> HIGH
    *	  LPP #STATE_2
    *	  LSR #CCDCLK              *     Write to CBB Board
    *     LRB #POST_RG             *     DELAY = n x 100ns
    *	  LPE

         ***** [STATE_3]          *     H1 -> LOW
         LPP #STATE_3
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
         LPE
         ***** [STATE_4]          *     H2 -> HIGH
         LPP #STATE_4
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
         LPE
         ***** [STATE_5]          *     H3 -> LOW
         LPP #STATE_5
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
         LPE
         ***** [STATE_6]          *     H1 -> HIGH
         LPP #STATE_6
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
         LPE
         ***** [STATE_7]          *     H2 -> LOW
         LPP #STATE_7
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
         LPE

         ***** [STATE_8]          *     H2 -> LOW
         LPP #STATE_8
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
         LPE

* V***** SKIPPER *****V

         ***** [STATE_8_DRAIN]          *     H3 -> HIGH
         LPP #STATE_8DG
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
         LPE

         * ***** [STATE_8]          *     H2 -> LOW
         * LPP #STATE_8
         * LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         * LRB #H_OVERLAP           *     DELAY = n x 100ns
         * LPE

         ***** [STATE_10_RESET_SN]            *     RESET SN
         LPP #STATE_10RG
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
         LPE

*JJJ    LRB #COLBIN                   * BEGIN Loop COLBIN. SKIPPER SAMPLES
    LRB #SHIFT_ROWS                   * BEGIN Loop COLBIN. SKIPPER SAMPLES


         ***** [STATE_8_INTEG]          *     H3 -> HIGH
         LPP #STATE_8
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
         LPE
         ***** [STATE_8A]         *     CDS_RST -> LOW; CDS_DCR -> LOW
         LPP #STATE_8A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_8B]         *     CDS_INT -> HIGH
         LPP #STATE_8B
         LSR #CCDACQ              *     Write to Video Board
         LRB #INTEG_WIDTH         *     DELAY = n x 100ns
         LPE
         ***** [STATE_8C]         *     CDS_INT -> LOW
         LPP #STATE_8C
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_8D]         *     CDS_NIN -> LOW
         LPP #STATE_8D            *     (Make NIN before break INV.)
         LSR #CCDACQ              *     WRITE TO Video Board
         ***** [STATE_8E]         *     CDS_INV -> HIGH
         LPP #STATE_8E
         LSR #CCDACQ
         *LRB #PRE_SW
         *LPE
         ***** [STATE_9]          *     SW -> HIGH
         LPP #STATE_9
         LDA #CLKPORT             *     REGISTER = CLKPORT
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #SW_WIDTH
         LPE
         ***** [STATE_10]         *     SW -> LOW
         LPP #STATE_10
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_SW          *     DELAY = n x 100n
         LPE
         ***** [STATE_10A]        *     CDS_INT -> HIGH
         LPP #STATE_10A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         LRB #INTEG_WIDTH         *     DELAY = n x 100 ns
         LPE
         ***** [STATE_10B]        *     CDS_INT -> LOW
         LPP #STATE_10B
         LSR #CCDACQ              *     Write to Video Board
         *LRB #PRE_CTC             *     DELAY = n x 100ns
         *LPE
         ***** [STATE_10C]        *     CDS_CTC -> HIGH
         LPP #STATE_10C
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_10D]        *     CDS_CTC -> LOW
         LPP #STATE_10D
         LSR #CCDACQ              *     Write to Video Board
         *LRB #POST_CTC            *     DELAY = n x 100ns
         *LPE
         ***** [STATE 10E]        *     Restore CDS_RST,CDS_DCR,CDS_NIN,CDS_INV
	     LPP #STATE_10E
	     LSR #CCDACQ              *     Write to Video Board

        * DUS #DAC_DELAY * JJJ
        * LDA #CLKPORT   * JJJ          *   REGISTER = CLKPORT
        * LSR #CCDCLK    * JJJ          *     BOARD SELECT = #CCDCLK
	     ***** [END LOOP]
        * JJJ LPE                      *   END LOOP


         ***** [STATE_10_CHARGE_BACK]          *     OG -> LOW
         LPP #STATE_10OG
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #SW_WIDTH
         LPE
         ***** [STATE_10]            *     OG -> HIGH
         LPP #STATE_10
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
         LPE

         ***** DO WE NEED TO RESET EACH TIME?
         ***** [STATE_10_RESET_SN]            *     RESET SN
         LPP #STATE_10RG
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
         LPE

   LPE                           * END Loop COLBIN. SKIPPER SAMPLES

   ***** [STATE_9]          *     SW -> HIGH
   LPP #STATE_9
   LDA #CLKPORT             *     REGISTER = CLKPORT
   LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
   LRB #SW_WIDTH
   LPE



   ***** [STATE_8_INTEG]          *     H3 -> HIGH
   LPP #STATE_8
   LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
   LRB #POST_H_CLK          *     DELAY = n x 100ns
   LPE
   
* ^***** SKIPPER *****^

   ***** [END COL LOOP]
   LPE                      *   END LOOP



   LRB #ROWBIN                    * BEGIN Loop ROWBIN
         ***** [STATE_11]         *   Tg -> LOW
         LPP #STATE_11
         DUS #DAC_DELAY
         LDA #CLKPORT             *   REGISTER = CLKPORT
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
         LPE
         ***** [STATE_12]         *   V3 -> LOW
         LPP #STATE_12
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
         LPE
         ***** [STATE_13]         *   V2 -> HIGH
         LPP #STATE_13
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	      LPE
         ***** [STATE_14]         *   V2 -> LOW
         LPP #STATE_14
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	      LPE
         ***** [STATE_15]         *   V3 -> HIGH
         LPP #STATE_15
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	      LPE
         ***** [STATE_16]         *   V2 -> LOW; Tg -> HIGH
         LPP #STATE_16
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	      LPE
   LPE                            * END Loop ROWBIN

         *****
         LPE                      * END LOOP
         RET


#READTYPE2  DUS #DELAY_20us       * DELAY 20 us
         LRB #ROWS                * BEGIN LOOP( ROWS)
         LRB #COLS                *   BEGIN LOOP( COLS)
	 LDA #CLKPORT             *     SET UP CLK OUTPUT PORT
         ***** [STATE_1]          *     Rg -> LOW
    *     LPP #STATE_1             *     INITIAL STATE
    *     LSR #CCDCLK              *     Write to CBB Board
    *     LRB #RG_WIDTH            *     DELAY = n x 100ns
    *  	  LPE
    *	  ***** [STATE_2]          *     Rg -> HIGH
    *	  LPP #STATE_2
    *	  LSR #CCDCLK              *     Write to CBB Board
    *     LRB #POST_RG             *     DELAY = n x 100ns
    *	  LPE
         ***** [STATE_3]          *     H1 -> LOW
	 LPP #R_STATE_3
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_4]          *     H2 -> HIGH
	 LPP #R_STATE_4
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_5]          *     H3 -> LOW
	 LPP #STATE_5
         LSR #CCDCLK              *     Write to CBB Board
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_6]          *     H1 -> HIGH
	 LPP #R_STATE_6
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_7]          *     H2 -> LOW
         LPP #R_STATE_7
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #H_OVERLAP           *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8]          *     H3 -> HIGH
         LPP #STATE_8
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #POST_H_CLK          *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8A]         *     CDS_RST -> LOW; CDS_DCR -> LOW
	 LPP #STATE_8A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_8B]         *     CDS_INT -> HIGH
	 LPP #STATE_8B
         LSR #CCDACQ              *     Write to Video Board
         LRB #INTEG_WIDTH         *     DELAY = n x 100ns
	 LPE
         ***** [STATE_8C]         *     CDS_INT -> LOW
	 LPP #STATE_8C
         LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_8D]         *     CDS_NIN -> LOW
         LPP #STATE_8D            *     (Make NIN before break INV.)
         LSR #CCDACQ              *     WRITE TO Video Board
         ***** [STATE_8E]         *     CDS_INV -> HIGH
         LPP #STATE_8E
         LSR #CCDACQ
         *LRB #PRE_SW
         *LPE
         ***** [STATE_9]          *     SW -> HIGH
         LPP #STATE_9
         LDA #CLKPORT             *     REGISTER = CLKPORT
         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
         LRB #SW_WIDTH
         LPE
         ***** [STATE_10]         *     SW -> LOW
*         LPP #STATE_10
*         LSR #CCDCLK              *     BOARD SELECT = #CCDCLK
*         *LRB #POST_SW             *     DELAY = n x 100n
*	 *LPE
         ***** [STATE_10A]        *     CDS_INT -> HIGH
         LPP #STATE_10A
         LDA #CDSREG              *     REGISTER = CDSREG
         LSR #CCDACQ              *     Write to Video Board
         LRB #INTEG_WIDTH         *     DELAY = n x 100 ns
	 LPE
         ***** [STATE_10B]        *     CDS_INT -> LOW
         LPP #STATE_10B
	 LSR #CCDACQ              *     Write to Video Board
         *LRB #PRE_CTC             *     DELAY = n x 100ns
	 *LPE
         ***** [STATE_10C]        *     CDS_CTC -> HIGH
         LPP #STATE_10C
	 LSR #CCDACQ              *     Write to Video Board
         *DSC #DELAY_100ns         *     DELAY 100 ns
         ***** [STATE_10D]        *     CDS_CTC -> LOW
         LPP #STATE_10D
	 LSR #CCDACQ              *     Write to Video Board
         *LRB #POST_CTC            *     DELAY = n x 100ns
	 *LPE
	 ***** [STATE 10E]        *     Restore CDS_RST,CDS_DCR,CDS_NIN,CDS_INV
	 LPP #STATE_10E
	 LSR #CCDACQ              *     Write to Video Board
	 ***** [END LOOP]
         LPE                      *   END LOOP
         ***** [STATE_11]         *   Tg -> LOW
         LPP #STATE_11
         DUS #DAC_DELAY
         LDA #CLKPORT             *   REGISTER = CLKPORT
         LSR #CCDCLK              *   Write to CBB Board
	 LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_12]         *   V3 -> LOW
         LPP #STATE_12
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_13]         *   V2 -> HIGH
         LPP #STATE_13
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_14]         *   V2 -> LOW
         LPP #STATE_14
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_15]         *   V3 -> HIGH
         LPP #STATE_15
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE
         ***** [STATE_16]         *   V2 -> LOW; Tg -> HIGH
         LPP #STATE_16
         LSR #CCDCLK              *   Write to CBB Board
         LRB #V_OVERLAP           *   DELAY = n x 100ns
	 LPE

         *****
         LPE                      * END LOOP
         RET

*****************************************************
* OPENS SHUTTER FOR n x 10ms                        *
*****************************************************

#EXPOSE  LMR #WRITE16
         LDA #DEVICE0             * Use DEVICE ADDR = 0
	 LPP #OPEN_SHUTTER
         LSR #CCDCLK              * Sets SHUTTER_OUTPUT (IO1) to 1
         LRB #COLBIN              * DELAY = n x 10 ms
	 DMS 10
	 LPE
	 LPP #CLOSE_SHUTTER       * Sets SHUTTER_OUTPUT (IO1) to 0
	 LSR #CCDCLK 
	 LMR #WRITE32             * RESTORE TRANSFER MODE
	 RET
