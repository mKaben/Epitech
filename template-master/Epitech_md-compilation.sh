#!/bin/bash

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%
#%%% EPITECH template compilation script
#%%%                                    v2.3
#%%%
#%%%                Pierre ROBERT
#%%%                          02/2018
#%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


SCRIPT_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$SCRIPT_DIR" ]]; then SCRIPT_DIR="$PWD"; fi

DEBUG=false

ERROR_CODE=1


#--------------------------------------------
# BINARIES CHECKING
#--------------------------------------------
function checkBinary
{
    if ! which $1 > /dev/null; then
        echo -e "$1 not found !"
        exit $ERROR_CODE
    fi
}

checkBinary gpp
checkBinary pandoc
checkBinary pdflatex



#--------------------------------------------
# ARGUMENTS CHECKING
#--------------------------------------------
USAGE="\nUSAGE : $0 [-l logo] [--slide] [--html] source.md\n\n"
USAGE+="\t-l logo (def:none) 	\tpresentation page logo (150p height)\n"
USAGE+="\t--slide (def:false) 	\tslideshow\n"
USAGE+="\t--html (def:false) 	\thtml export\n"
USAGE+="\tsource.md     	 	\tmd file to be compiled\n"
LOGO=-1
HTMLexport=false
slideShow=false
while getopts ":l:-:" name
do
    case $name in
        l)      LOGO=$OPTARG;;
        -)
            case "${OPTARG}" in
                html)       HTMLexport=true;;
                slide)      slideShow=true;;
                *)          echo -e "$USAGE";exit $ERROR_CODE;;
            esac;;
        *)      echo -e "$USAGE"; exit $ERROR_CODE;;
    esac
done

shift $((OPTIND-1))

if [ $# -ne 1 ]; then
    echo -e "$USAGE"

    exit $ERROR_CODE
fi

SOURCE_FILE="$1"
if [ ! -e "$SOURCE_FILE" ]; then
    SOURCE_FILE="$1.md"
fi
if [ ! -e "$SOURCE_FILE" ]; then
    SOURCE_FILE="$1md"
fi
if [ ! -e "$SOURCE_FILE" ]; then
    echo -e "\nSource $1 not found...\n"
    exit $ERROR_CODE
fi

v=`egrep "slideshow:(\s)*true" "$SOURCE_FILE" | wc -c`

if [ $v -ge 15 ]; then
    slideShow=true
fi

v=`egrep "debug:(\s)*true" "$SOURCE_FILE" | wc -c`
if [ $v -ge 11 ]; then
    DEBUG=true
fi


#--------------------------------------------
# FILE AND DIR NAMES
#--------------------------------------------
SOURCE_DIR=./${SOURCE_FILE%.md}
SOURCE_DIR=${SOURCE_DIR%/*}
OUTPUT_FILENAME=${SOURCE_FILE%.md}
OUTPUT_FILENAME=${OUTPUT_FILENAME##*/}
IMG_DIR="$SCRIPT_DIR/$TEMPLATE_DIR/img"
MACRO_FILE="$SCRIPT_DIR/Epitech_template_macros.gpp"
MACRO_FILE2="$SCRIPT_DIR/Epitech_template_macros2.gpp"

if [ -e $LOGO ]; then
    echo -e "logo file $LOGO found...\n"
elif [ `ls $SOURCE_DIR/logo*.png $SOURCE_DIR/logo*.jpg 2>/dev/null | wc -w` -ge 1 ]; then
    LOGO=`ls -x $SOURCE_DIR/logo.png $SOURCE_DIR/logo*.jpg 2>/dev/null | cut -d" " -f1`
    echo -e "logo file $LOGO found...\n"
else
    echo -e "\n/!\ no logo file found...\n"
    LOGO="$IMG_DIR/pixelTransparent.png"
fi



#--------------------------------------------
# UNITS LAYOUTS DESCRIPTION FILE PARSING
#--------------------------------------------
UNITS_FILE="${SCRIPT_DIR}/unitDesc.tex"
touch "${UNITS_FILE}"
unit=`egrep "module:[[:space:]]*" "$SOURCE_FILE" | cut -d':' -f2 | tr -d '[:space:]'`
SEP=';'
if [ -z "$unit" ]; then
    echo -e "/!\ No unit code found. Probably not a subject file. Exiting without errors."
    exit 0
fi

while read line
do
    codeNum="00"`echo $line | cut -d$SEP -f3`
    codeNum="${codeNum:$((${#codeNum}-3))}"
    code=`echo $line | cut -d$SEP -f1-2 | tr $SEP '-'`"-$codeNum"
    if [ "$unit" != "$code" ] ; then
        code=`echo $line | cut -d$SEP -f2`
    fi
    if [ "$unit" = "$code" ] ; then
        name=`echo $line | cut -d$SEP -f4  | sed -e s/\&/\\\\\\\\\&/g | sed -e 's/_/\\\\_/g'`
        semester=`echo $line | cut -d$SEP -f5`
        r=`echo $line | cut -d$SEP -f6`
        g=`echo $line | cut -d$SEP -f7`
        b=`echo $line | cut -d$SEP -f8`
        echo "\\renewcommand{\moduleName}{$name}
        \\renewcommand{\semester}{$semester}
        \\initializeColors{$r}{$g}{$b}" > "${UNITS_FILE}"
        break
    fi
done < "${SCRIPT_DIR}/Epitech_template_units.csv"
if [ "$unit" != "$code" ]; then
    echo -e "/!\ Unit code $unit not found in the Epitech_template_units.csv file.\nPlease add it."
    exit $ERROR_CODE
fi




#--------------------------------------------
# COMPILATION
#--------------------------------------------
EXTENSIONS=hard_line_breaks+simple_tables
PANDOC_OPTIONS=--listings
PANDOC_TEMPLATE="default"
cp "$LOGO" "$IMG_DIR/logo.png"


function pdflatexCall
{
    INPUTS="$SCRIPT_DIR:$SCRIPT_DIR/img"
    if [ -d "`pwd`/$SCRIPT_DIR/img" ] ; then
        INPUTS="`pwd`/$SCRIPT_DIR:`pwd`/$SCRIPT_DIR/img"
    fi

    TEXINPUTS="$INPUTS:$TEXINPUTS" \
              openout_any=a pdflatex -halt-on-error --interaction=nonstopmode -file-line-error -draftmode --jobname="${SOURCE_DIR}/${OUTPUT_FILENAME}" "${SOURCE_DIR}/${OUTPUT_FILENAME}.tex" && \
    TEXINPUTS="$INPUTS:$TEXINPUTS" \
              openout_any=a pdflatex --jobname="${SOURCE_DIR}/${OUTPUT_FILENAME}" "${SOURCE_DIR}/${OUTPUT_FILENAME}.tex" >/dev/null
}

MESSAGE=""
OUTPUT_EXT="tex"

if [ $slideShow = true ] && [ $HTMLexport = true ]; then
    MESSAGE="HTML slideshow"
    PANDOC_OPTIONS+=" -t dzslides"
    OUTPUT_EXT="html"

elif [ $slideShow = true ]; then
    MESSAGE="PDF slideshow"
    PANDOC_OPTIONS+=" --standalone --slide-level 2 -t beamer"
    PANDOC_TEMPLATE="${SCRIPT_DIR}/templates/default.beamer"

elif [ $HTMLexport = true ]; then
    MESSAGE="HTML"
    OUTPUT_EXT="html"

else
    MESSAGE="PDF"
    PANDOC_TEMPLATE="${SCRIPT_DIR}/templates/default.latex"
fi

echo -e "\n[COMPILATION]" $MESSAGE "generation..."
cat "${SOURCE_FILE}" | \
    sed 's;\\;\\\\;g' | \
    gpp -U "#" "" "(" "|," ")" "(" ")" "#" "\\" -M "#" "\n" " " " " "\n" "(" ")" --include "${MACRO_FILE}" | \
    gpp -U "#" "" "(" "," ")" "(" ")" "#" "\\" -M "#" "\n" " " " " "\n" "(" ")" --include "${MACRO_FILE2}" | \
    pandoc -s -f markdown+$EXTENSIONS ${PANDOC_OPTIONS} --template="$PANDOC_TEMPLATE" -o "${SOURCE_DIR}/${OUTPUT_FILENAME}.${OUTPUT_EXT}" && \
    (${HTMLexport} || pdflatexCall)
exit_status=$?



#--------------------------------------------
# NETTOYAGE
#--------------------------------------------
echo -e "[COMPILATION] cleaning...\n"
rm -f "${SOURCE_DIR}/$OUTPUT_FILENAME.aux" \
    "${SOURCE_DIR}/$OUTPUT_FILENAME.log" \
    "${SOURCE_DIR}/$OUTPUT_FILENAME.out" \
    "${SOURCE_DIR}/$OUTPUT_FILENAME.nav" \
    "${SOURCE_DIR}/$OUTPUT_FILENAME.nvm" \
    "${SOURCE_DIR}/$OUTPUT_FILENAME.snm" \
    "${SOURCE_DIR}/$OUTPUT_FILENAME.toc" \
    "${SOURCE_DIR}/$OUTPUT_FILENAME.vrb" \
    "$IMG_DIR/logo.png"
if [ $DEBUG = false ]; then
    rm -f "${SOURCE_DIR}/$OUTPUT_FILENAME.tex" \
    "$UNITS_FILE"
fi

exit $exit_status
