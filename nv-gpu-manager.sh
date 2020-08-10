#!/bin/bash

if [ "$#" -eq  "0" ]
  then
    echo -e "ERROR: No arguments supplied, please provide a valid argument:"
    echo -e "> -k,--kill\n\tCuts the gpu power off"
    echo -e "> -s,--start\n\tTurns the gpu power on" 
else
    case "$1" in
        -k|--kill )
            # Choose integrated gpu for graphics
            sudo prime-select intel
            
            # Unload Nvidia Modules
            sudo modprobe -r nvidia
            sudo modprobe -r nvidia_modeset
            
            # Check if nvidia GPU is being used
            if xrandr --listproviders | grep NVIDIA; then
            	echo "GPU is in use for PRIME, keeping on"
            else
                # Load acpi-call-dkms kenrel module
                sudo modprobe acpi_call 
            
                # Turn GPU off with acpi_call
            	sudo sh -c 'echo "\\_SB.PCI0.GPP0.PG00._OFF" > /proc/acpi/call'
            
                echo "GPU powered off"
            fi  
        ;;
        -s|--start )
            # Choose nvidia gpu for graphics
            sudo prime-select on-demand
            
            # Load Nvidia Modules
            sudo modprobe nvidia
            sudo modprobe nvidia_modeset
            
            # Load acpi-call-dkms kenrel module
            sudo modprobe acpi_call 
            
            # Turn GPU on with acpi_call
            sudo sh -c 'echo "\\_SB.PCI0.GPP0.PG00._ON" > /proc/acpi/call'
            
            echo "GPU powered on"
        ;;
        *)
            echo "Please provide a valid argument:" 
            echo -e "> -k,--kill\n\tCuts the gpu power off"
            echo -e "> -s,--start\n\tTurns the gpu power on" 
        ;;
    esac 
fi




