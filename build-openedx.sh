
#!/bin/bash
#------------------------------------------------------------------------------
# written by:   Lawrence McDaniel
#               https://lawrencemcdaniel.com
# date:         2024-08-19
#
# usage:        Open edX tutor LMS and CMS configuration
#------------------------------------------------------------------------------

cd ~
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
else
    echo "Error: venv/bin/activate does not exist. Create a Python virtual environment and install Tutor."
    exit 1
fi

# grab the custom theme repo
if [ -d "edx-theme-eiaeducation" ]; then
    cd edx-theme-eiaeducation
    git pull
    cd ~
    echo "pulled latest changes from edx-theme-eiaeducation"
else
    git clone https://github.com/eiaeducation/edx-theme-eiaeducation.git
    echo "cloned edx-theme-eiaeducation"
fi

# move the theme into tutor's themes directory
THEMES_PATH=$(tutor config printroot)/env/build/openedx/themes
mv edx-theme-eiaeducation $THEMES_PATH/
echo "moved edx-theme-eiaeducation to $THEMES_PATH"

# set the theme
tutor local do settheme edx-theme-eiaeducation
tutor config save

echo "build openedx"
tutor images build openedx
