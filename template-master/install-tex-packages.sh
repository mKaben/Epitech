#!/usr/bin/env sh

################################################################################
# Make sure tlmgr itself is up-to-date
################################################################################

tlmgr update --self

################################################################################
# Install Epitech latex packages
################################################################################

tlmgr install wasysym \
              courier \
              titlesec \
              needspace \
              comfortaa \
              cabin \
              moresize \
              tcolorbox \
              mdframed \
              wrapfig \
              enumitem \
              currfile \
              xstring \
              fontaxes \
              mweights \
              environ \
              trimspaces \
              zref \
              || exit 1

################################################################################
# Trim down (possibly large amounts of) installed artifacts such as docs.      #
################################################################################
rm -rf /opt/texlive/texdir/texmf-dist/doc  \
       /opt/texlive/texdir/readme-html.dir \
       /opt/texlive/texdir/readme-txt.dir  \
       /opt/texlive/texdir/install-tl*
