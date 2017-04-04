## Condition the clocks on the MCB
mcbseqEnable=0   # Kill the sequencer run flag
mcbBkplnSlct=0   # for a 6 slot backplane
#mcbClkEnables=0xff

# set sampling mode
set sampling singframe

# upload sequencer code
#memory load sequencer file skipper.ucd
#memory load sequencer file skipper_testingCable.ucd
memory load sequencer file skipper_testingCable_3DG.ucd

# setup dacs and register values
macro decam55_newSetupClr.mod -force
 macro 16bppx2.mc


#start the sequencer
mcbseqEnable=1   

#we are the master 
dheMstr=1

# be sure we know where we start
set binning 1 1

#set it to multiple extensions
set image.extensions yes

#uncomment to have 1 extension per CCD
#leave it commented to have 1 extension per amplifier
set image.detext on

#set the timing values
macro timing

#enable TestPoints
memory write 16 none 0x258-0x25d 0
memory write 8 none 0x258-0x25d 0

#disable autoclear
set autoclear off

#move overscan to the edge
#set modifiers xorder pre pos data

#macro dhe_read_lowerboth4ch

#start the loop for monitoring defined TestPoints
TP suscribe
TP add -all

