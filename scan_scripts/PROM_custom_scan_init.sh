#!/bin/csh
# scan script called periodically by cron
cd $HOME
set distr = /home/data/metek/m36s
set path = ( $distr/bin /bin /usr/bin )

# do nothing if the radar is in maintenance mode
if ( ! -e ~/.get_processing ) then
    echo "The radar seems to be in mainenance mode, i.e. ~/.get_processing doesn't exist."
    echo "get_processing without the option executed_by_cron=1 switches from maintenance mode to measurement mode."
    echo "kill_processing without the option executed_by_cron=1 switches from measurement mode to maintenance mode."
    echo "Alternatively the commands maintenance_mode 1 or maintenance_mode 0 can be used to switch on or off the maintenance mode."
    exit
endif

if (  "`check_aerotech|tail -1`" == "OK" ) then
    ### if ( `wr | grep TempAir | sed 's/TempWarm =\(.*\)\..*$/\1/'` > 2 ) then

        # check if manual scanning is going on, if so quit this (by cron) called ppi scan
        if ( -e ~/.scanning_manually ) then
            #passed_scan_time=expr `date +%s` - `date -r ~/.scanning_manually +%s`
            #if ( expr `passed_scan_time` <= `30*60` ) then
            echo "Manual scanning is going on, started at `date -r ~/.scanning_manually`, remove ~/.scanning_manually if this is wrong"
            exit
        endif


       if ( -e ~/.scanning ) then
            #passed_scan_time=expr `date +%s` - `date -r ~/.scanning_manually +%s`
            #if ( expr `passed_scan_time` <= `30*60` ) then
            echo "Automatic canning is going on, started at `date -r ~/.scanning`, remove ~/.scanning if this is wrong"
            exit
        endif

        touch ~/.scanning
        killall aerotechcmd # shold not be needed if everything is running perfectly
        sleep 1

        echo starting aerotechcmd at `date`
        kill_processing executed_by_cron=1

        ### rhi_scan support the following arguments by givin them in order, or defaults to 
        #
		/home/data/PROM/scan_scripts/PROM_custom_scan.txt

        echo finished scan-script at `date`
        rm ~/.scanning
        get_processing executed_by_cron=1
endif
