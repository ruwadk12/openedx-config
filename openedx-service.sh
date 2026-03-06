#!/bin/bash
#------------------------------------------------------------------------------
# This script sets up the Open edX platform service on an Ubuntu system
# so that the platform will automatically start on system boot and can 
# be managed using systemctl.
#------------------------------------------------------------------------------


sudo systemctl daemon-reload
sudo systemctl enable tutor.service
sudo systemctl start tutor.service
sudo systemctl status tutor.service