[0]
NEXTEND ='dbs num_ext       ' /Number of extensions     
FILENAME='dbs imname        ' /Filename     
PROCTYPE='Raw               ' /Data processing level     
PRODTYPE='image             ' /Data product type     
PANID   ='dbs nodeID        ' /PAN identification     
DETSIZE ='dbs fpasize_bin   ' /Detector size     
PSCINFO ='file PIXSCALE_INFO.tpl' /pixel scale information file     
UTSHUT  ='queue             ' /UT shutter open     
DHEINFO ='dbs 2DARR DHEINFO ' /template on DHE_INFO.tpl     
NSAMP   ='dbs nsamp         ' /number of samples     
[1-*]
BUNIT   ='adu               ' /Brightness units for pixel array
CCDSUM  ='dbs ccdsum        ' / CCD pixel binning
GEOMETRY='queue             ' /template on GEOM_INFO.tpl
