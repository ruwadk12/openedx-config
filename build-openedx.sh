
#!/bin/bash
#------------------------------------------------------------------------------
# written by:   Lawrence McDaniel
#               https://lawrencemcdaniel.com
# date:         2026-03-4
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
if [ -d "edx-theme-ruwadk12" ]; then
    cd edx-theme-ruwadk12
    git pull
    cd ~
    echo "pulled latest changes from edx-theme-ruwadk12"
else
    git clone https://github.com/ruwadk12/edx-theme-ruwadk12.git
    echo "cloned edx-theme-ruwadk12"
fi

# move the theme into tutor's themes directory
THEMES_PATH=$(tutor config printroot)/env/build/openedx/themes
mv edx-theme-ruwadk12 $THEMES_PATH/
echo "moved edx-theme-ruwadk12 to $THEMES_PATH"

# set the theme
tutor local do settheme edx-theme-ruwadk12
tutor config save

echo "build openedx"
tutor images build openedx
