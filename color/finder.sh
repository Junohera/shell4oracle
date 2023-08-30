#!/bin/sh

clear;
current_path=$(dirname $(realpath $0))
. "${current_path}/.color.env"

tempfile1="${current_path}/.temp1.sample.sh"
tempfile2="${current_path}/.temp2.sample.sh"


echoBlack () { echo "💎💎💎💎💎💎💎💎💎💎   Black 💎💎💎💎💎💎💎💎💎💎"; echo -n "$(ECHO_BLACK "black") $(ECHO_BLACK_BOLD "blackBold") $(ECHO_BLACK_SINGLE "blackSingle") $(ECHO_BLACK_GLOW "blackGlow") $(ECHO_BLACK_INVERSE "blackInverse") $(ECHO_BLACK_DOUBLE "blackDouble") $(ECHO_BLACK_BLACK "blackBlack") $(ECHO_BLACK_BLACK_BOLD "blackBlackBold") $(ECHO_BLACK_BLACK_SINGLE "blackBlackSingle") $(ECHO_BLACK_BLACK_GLOW "blackBlackGlow") $(ECHO_BLACK_BLACK_INVERSE "blackBlackInverse") $(ECHO_BLACK_BLACK_DOUBLE "blackBlackDouble") $(ECHO_BLACK_RED "blackRed") $(ECHO_BLACK_RED_BOLD "blackRedBold") $(ECHO_BLACK_RED_SINGLE "blackRedSingle") $(ECHO_BLACK_RED_GLOW "blackRedGlow") $(ECHO_BLACK_RED_INVERSE "blackRedInverse") $(ECHO_BLACK_RED_DOUBLE "blackRedDouble") $(ECHO_BLACK_GREEN "blackGreen") $(ECHO_BLACK_GREEN_BOLD "blackGreenBold") $(ECHO_BLACK_GREEN_SINGLE "blackGreenSingle") $(ECHO_BLACK_GREEN_GLOW "blackGreenGlow") $(ECHO_BLACK_GREEN_INVERSE "blackGreenInverse") $(ECHO_BLACK_GREEN_DOUBLE "blackGreenDouble") $(ECHO_BLACK_BROWN "blackBrown") $(ECHO_BLACK_BROWN_BOLD "blackBrownBold") $(ECHO_BLACK_BROWN_SINGLE "blackBrownSingle") $(ECHO_BLACK_BROWN_GLOW "blackBrownGlow") $(ECHO_BLACK_BROWN_INVERSE "blackBrownInverse") $(ECHO_BLACK_BROWN_DOUBLE "blackBrownDouble") $(ECHO_BLACK_PURPLE "blackPurple") $(ECHO_BLACK_PURPLE_BOLD "blackPurpleBold") $(ECHO_BLACK_PURPLE_SINGLE "blackPurpleSingle") $(ECHO_BLACK_PURPLE_GLOW "blackPurpleGlow") $(ECHO_BLACK_PURPLE_INVERSE "blackPurpleInverse") $(ECHO_BLACK_PURPLE_DOUBLE "blackPurpleDouble") $(ECHO_BLACK_PURPLE "blackPurple") $(ECHO_BLACK_PURPLE_BOLD "blackPurpleBold") $(ECHO_BLACK_PURPLE_SINGLE "blackPurpleSingle") $(ECHO_BLACK_PURPLE_GLOW "blackPurpleGlow") $(ECHO_BLACK_PURPLE_INVERSE "blackPurpleInverse") $(ECHO_BLACK_PURPLE_DOUBLE "blackPurpleDouble") $(ECHO_BLACK_CYAN "blackCyan") $(ECHO_BLACK_CYAN_BOLD "blackCyanBold") $(ECHO_BLACK_CYAN_SINGLE "blackCyanSingle") $(ECHO_BLACK_CYAN_GLOW "blackCyanGlow") $(ECHO_BLACK_CYAN_INVERSE "blackCyanInverse") $(ECHO_BLACK_CYAN_DOUBLE "blackCyanDouble") $(ECHO_BLACK_WHITE "blackWhite") $(ECHO_BLACK_WHITE_BOLD "blackWhiteBold") $(ECHO_BLACK_WHITE_SINGLE "blackWhiteSingle") $(ECHO_BLACK_WHITE_GLOW "blackWhiteGlow") $(ECHO_BLACK_WHITE_INVERSE "blackWhiteInverse") $(ECHO_BLACK_WHITE_DOUBLE "blackWhiteDouble")"; echo; }
echoRed () { echo "💎💎💎💎💎💎💎💎💎💎     Red 💎💎💎💎💎💎💎💎💎💎"; echo -n "$(ECHO_RED "red") $(ECHO_RED_BOLD "redBold") $(ECHO_RED_SINGLE "redSingle") $(ECHO_RED_GLOW "redGlow") $(ECHO_RED_INVERSE "redInverse") $(ECHO_RED_DOUBLE "redDouble") $(ECHO_RED_BLACK "redBlack") $(ECHO_RED_BLACK_BOLD "redBlackBold") $(ECHO_RED_BLACK_SINGLE "redBlackSingle") $(ECHO_RED_BLACK_GLOW "redBlackGlow") $(ECHO_RED_BLACK_INVERSE "redBlackInverse") $(ECHO_RED_BLACK_DOUBLE "redBlackDouble") $(ECHO_RED_RED "redRed") $(ECHO_RED_RED_BOLD "redRedBold") $(ECHO_RED_RED_SINGLE "redRedSingle") $(ECHO_RED_RED_GLOW "redRedGlow") $(ECHO_RED_RED_INVERSE "redRedInverse") $(ECHO_RED_RED_DOUBLE "redRedDouble") $(ECHO_RED_GREEN "redGreen") $(ECHO_RED_GREEN_BOLD "redGreenBold") $(ECHO_RED_GREEN_SINGLE "redGreenSingle") $(ECHO_RED_GREEN_GLOW "redGreenGlow") $(ECHO_RED_GREEN_INVERSE "redGreenInverse") $(ECHO_RED_GREEN_DOUBLE "redGreenDouble") $(ECHO_RED_BROWN "redBrown") $(ECHO_RED_BROWN_BOLD "redBrownBold") $(ECHO_RED_BROWN_SINGLE "redBrownSingle") $(ECHO_RED_BROWN_GLOW "redBrownGlow") $(ECHO_RED_BROWN_INVERSE "redBrownInverse") $(ECHO_RED_BROWN_DOUBLE "redBrownDouble") $(ECHO_RED_PURPLE "redPurple") $(ECHO_RED_PURPLE_BOLD "redPurpleBold") $(ECHO_RED_PURPLE_SINGLE "redPurpleSingle") $(ECHO_RED_PURPLE_GLOW "redPurpleGlow") $(ECHO_RED_PURPLE_INVERSE "redPurpleInverse") $(ECHO_RED_PURPLE_DOUBLE "redPurpleDouble") $(ECHO_RED_PURPLE "redPurple") $(ECHO_RED_PURPLE_BOLD "redPurpleBold") $(ECHO_RED_PURPLE_SINGLE "redPurpleSingle") $(ECHO_RED_PURPLE_GLOW "redPurpleGlow") $(ECHO_RED_PURPLE_INVERSE "redPurpleInverse") $(ECHO_RED_PURPLE_DOUBLE "redPurpleDouble") $(ECHO_RED_CYAN "redCyan") $(ECHO_RED_CYAN_BOLD "redCyanBold") $(ECHO_RED_CYAN_SINGLE "redCyanSingle") $(ECHO_RED_CYAN_GLOW "redCyanGlow") $(ECHO_RED_CYAN_INVERSE "redCyanInverse") $(ECHO_RED_CYAN_DOUBLE "redCyanDouble") $(ECHO_RED_WHITE "redWhite") $(ECHO_RED_WHITE_BOLD "redWhiteBold") $(ECHO_RED_WHITE_SINGLE "redWhiteSingle") $(ECHO_RED_WHITE_GLOW "redWhiteGlow") $(ECHO_RED_WHITE_INVERSE "redWhiteInverse") $(ECHO_RED_WHITE_DOUBLE "redWhiteDouble")"; echo; }
echoGreen () { echo "💎💎💎💎💎💎💎💎💎💎   Green 💎💎💎💎💎💎💎💎💎💎"; echo -n "$(ECHO_GREEN "green") $(ECHO_GREEN_BOLD "greenBold") $(ECHO_GREEN_SINGLE "greenSingle") $(ECHO_GREEN_GLOW "greenGlow") $(ECHO_GREEN_INVERSE "greenInverse") $(ECHO_GREEN_DOUBLE "greenDouble") $(ECHO_GREEN_BLACK "greenBlack") $(ECHO_GREEN_BLACK_BOLD "greenBlackBold") $(ECHO_GREEN_BLACK_SINGLE "greenBlackSingle") $(ECHO_GREEN_BLACK_GLOW "greenBlackGlow") $(ECHO_GREEN_BLACK_INVERSE "greenBlackInverse") $(ECHO_GREEN_BLACK_DOUBLE "greenBlackDouble") $(ECHO_GREEN_RED "greenRed") $(ECHO_GREEN_RED_BOLD "greenRedBold") $(ECHO_GREEN_RED_SINGLE "greenRedSingle") $(ECHO_GREEN_RED_GLOW "greenRedGlow") $(ECHO_GREEN_RED_INVERSE "greenRedInverse") $(ECHO_GREEN_RED_DOUBLE "greenRedDouble") $(ECHO_GREEN_GREEN "greenGreen") $(ECHO_GREEN_GREEN_BOLD "greenGreenBold") $(ECHO_GREEN_GREEN_SINGLE "greenGreenSingle") $(ECHO_GREEN_GREEN_GLOW "greenGreenGlow") $(ECHO_GREEN_GREEN_INVERSE "greenGreenInverse") $(ECHO_GREEN_GREEN_DOUBLE "greenGreenDouble") $(ECHO_GREEN_BROWN "greenBrown") $(ECHO_GREEN_BROWN_BOLD "greenBrownBold") $(ECHO_GREEN_BROWN_SINGLE "greenBrownSingle") $(ECHO_GREEN_BROWN_GLOW "greenBrownGlow") $(ECHO_GREEN_BROWN_INVERSE "greenBrownInverse") $(ECHO_GREEN_BROWN_DOUBLE "greenBrownDouble") $(ECHO_GREEN_PURPLE "greenPurple") $(ECHO_GREEN_PURPLE_BOLD "greenPurpleBold") $(ECHO_GREEN_PURPLE_SINGLE "greenPurpleSingle") $(ECHO_GREEN_PURPLE_GLOW "greenPurpleGlow") $(ECHO_GREEN_PURPLE_INVERSE "greenPurpleInverse") $(ECHO_GREEN_PURPLE_DOUBLE "greenPurpleDouble") $(ECHO_GREEN_PURPLE "greenPurple") $(ECHO_GREEN_PURPLE_BOLD "greenPurpleBold") $(ECHO_GREEN_PURPLE_SINGLE "greenPurpleSingle") $(ECHO_GREEN_PURPLE_GLOW "greenPurpleGlow") $(ECHO_GREEN_PURPLE_INVERSE "greenPurpleInverse") $(ECHO_GREEN_PURPLE_DOUBLE "greenPurpleDouble") $(ECHO_GREEN_CYAN "greenCyan") $(ECHO_GREEN_CYAN_BOLD "greenCyanBold") $(ECHO_GREEN_CYAN_SINGLE "greenCyanSingle") $(ECHO_GREEN_CYAN_GLOW "greenCyanGlow") $(ECHO_GREEN_CYAN_INVERSE "greenCyanInverse") $(ECHO_GREEN_CYAN_DOUBLE "greenCyanDouble") $(ECHO_GREEN_WHITE "greenWhite") $(ECHO_GREEN_WHITE_BOLD "greenWhiteBold") $(ECHO_GREEN_WHITE_SINGLE "greenWhiteSingle") $(ECHO_GREEN_WHITE_GLOW "greenWhiteGlow") $(ECHO_GREEN_WHITE_INVERSE "greenWhiteInverse") $(ECHO_GREEN_WHITE_DOUBLE "greenWhiteDouble")"; echo; }
echoYellow () { echo "💎💎💎💎💎💎💎💎💎💎  Yellow 💎💎💎💎💎💎💎💎💎💎"; echo -n "$(ECHO_YELLOW "yellow") $(ECHO_YELLOW_BOLD "yellowBold") $(ECHO_YELLOW_SINGLE "yellowSingle") $(ECHO_YELLOW_GLOW "yellowGlow") $(ECHO_YELLOW_INVERSE "yellowInverse") $(ECHO_YELLOW_DOUBLE "yellowDouble") $(ECHO_YELLOW_BLACK "yellowBlack") $(ECHO_YELLOW_BLACK_BOLD "yellowBlackBold") $(ECHO_YELLOW_BLACK_SINGLE "yellowBlackSingle") $(ECHO_YELLOW_BLACK_GLOW "yellowBlackGlow") $(ECHO_YELLOW_BLACK_INVERSE "yellowBlackInverse") $(ECHO_YELLOW_BLACK_DOUBLE "yellowBlackDouble") $(ECHO_YELLOW_RED "yellowRed") $(ECHO_YELLOW_RED_BOLD "yellowRedBold") $(ECHO_YELLOW_RED_SINGLE "yellowRedSingle") $(ECHO_YELLOW_RED_GLOW "yellowRedGlow") $(ECHO_YELLOW_RED_INVERSE "yellowRedInverse") $(ECHO_YELLOW_RED_DOUBLE "yellowRedDouble") $(ECHO_YELLOW_GREEN "yellowGreen") $(ECHO_YELLOW_GREEN_BOLD "yellowGreenBold") $(ECHO_YELLOW_GREEN_SINGLE "yellowGreenSingle") $(ECHO_YELLOW_GREEN_GLOW "yellowGreenGlow") $(ECHO_YELLOW_GREEN_INVERSE "yellowGreenInverse") $(ECHO_YELLOW_GREEN_DOUBLE "yellowGreenDouble") $(ECHO_YELLOW_BROWN "yellowBrown") $(ECHO_YELLOW_BROWN_BOLD "yellowBrownBold") $(ECHO_YELLOW_BROWN_SINGLE "yellowBrownSingle") $(ECHO_YELLOW_BROWN_GLOW "yellowBrownGlow") $(ECHO_YELLOW_BROWN_INVERSE "yellowBrownInverse") $(ECHO_YELLOW_BROWN_DOUBLE "yellowBrownDouble") $(ECHO_YELLOW_PURPLE "yellowPurple") $(ECHO_YELLOW_PURPLE_BOLD "yellowPurpleBold") $(ECHO_YELLOW_PURPLE_SINGLE "yellowPurpleSingle") $(ECHO_YELLOW_PURPLE_GLOW "yellowPurpleGlow") $(ECHO_YELLOW_PURPLE_INVERSE "yellowPurpleInverse") $(ECHO_YELLOW_PURPLE_DOUBLE "yellowPurpleDouble") $(ECHO_YELLOW_PURPLE "yellowPurple") $(ECHO_YELLOW_PURPLE_BOLD "yellowPurpleBold") $(ECHO_YELLOW_PURPLE_SINGLE "yellowPurpleSingle") $(ECHO_YELLOW_PURPLE_GLOW "yellowPurpleGlow") $(ECHO_YELLOW_PURPLE_INVERSE "yellowPurpleInverse") $(ECHO_YELLOW_PURPLE_DOUBLE "yellowPurpleDouble") $(ECHO_YELLOW_CYAN "yellowCyan") $(ECHO_YELLOW_CYAN_BOLD "yellowCyanBold") $(ECHO_YELLOW_CYAN_SINGLE "yellowCyanSingle") $(ECHO_YELLOW_CYAN_GLOW "yellowCyanGlow") $(ECHO_YELLOW_CYAN_INVERSE "yellowCyanInverse") $(ECHO_YELLOW_CYAN_DOUBLE "yellowCyanDouble") $(ECHO_YELLOW_WHITE "yellowWhite") $(ECHO_YELLOW_WHITE_BOLD "yellowWhiteBold") $(ECHO_YELLOW_WHITE_SINGLE "yellowWhiteSingle") $(ECHO_YELLOW_WHITE_GLOW "yellowWhiteGlow") $(ECHO_YELLOW_WHITE_INVERSE "yellowWhiteInverse") $(ECHO_YELLOW_WHITE_DOUBLE "yellowWhiteDouble")"; echo; }
echoPurple () { echo "💎💎💎💎💎💎💎💎💎💎    Purple 💎💎💎💎💎💎💎💎💎💎"; echo -n "$(ECHO_PURPLE "purple") $(ECHO_PURPLE_BOLD "purpleBold") $(ECHO_PURPLE_SINGLE "purpleSingle") $(ECHO_PURPLE_GLOW "purpleGlow") $(ECHO_PURPLE_INVERSE "purpleInverse") $(ECHO_PURPLE_DOUBLE "purpleDouble") $(ECHO_PURPLE_BLACK "purpleBlack") $(ECHO_PURPLE_BLACK_BOLD "purpleBlackBold") $(ECHO_PURPLE_BLACK_SINGLE "purpleBlackSingle") $(ECHO_PURPLE_BLACK_GLOW "purpleBlackGlow") $(ECHO_PURPLE_BLACK_INVERSE "purpleBlackInverse") $(ECHO_PURPLE_BLACK_DOUBLE "purpleBlackDouble") $(ECHO_PURPLE_RED "purpleRed") $(ECHO_PURPLE_RED_BOLD "purpleRedBold") $(ECHO_PURPLE_RED_SINGLE "purpleRedSingle") $(ECHO_PURPLE_RED_GLOW "purpleRedGlow") $(ECHO_PURPLE_RED_INVERSE "purpleRedInverse") $(ECHO_PURPLE_RED_DOUBLE "purpleRedDouble") $(ECHO_PURPLE_GREEN "purpleGreen") $(ECHO_PURPLE_GREEN_BOLD "purpleGreenBold") $(ECHO_PURPLE_GREEN_SINGLE "purpleGreenSingle") $(ECHO_PURPLE_GREEN_GLOW "purpleGreenGlow") $(ECHO_PURPLE_GREEN_INVERSE "purpleGreenInverse") $(ECHO_PURPLE_GREEN_DOUBLE "purpleGreenDouble") $(ECHO_PURPLE_BROWN "purpleBrown") $(ECHO_PURPLE_BROWN_BOLD "purpleBrownBold") $(ECHO_PURPLE_BROWN_SINGLE "purpleBrownSingle") $(ECHO_PURPLE_BROWN_GLOW "purpleBrownGlow") $(ECHO_PURPLE_BROWN_INVERSE "purpleBrownInverse") $(ECHO_PURPLE_BROWN_DOUBLE "purpleBrownDouble") $(ECHO_PURPLE_PURPLE "purplePurple") $(ECHO_PURPLE_PURPLE_BOLD "purplePurpleBold") $(ECHO_PURPLE_PURPLE_SINGLE "purplePurpleSingle") $(ECHO_PURPLE_PURPLE_GLOW "purplePurpleGlow") $(ECHO_PURPLE_PURPLE_INVERSE "purplePurpleInverse") $(ECHO_PURPLE_PURPLE_DOUBLE "purplePurpleDouble") $(ECHO_PURPLE_PURPLE "purplePurple") $(ECHO_PURPLE_PURPLE_BOLD "purplePurpleBold") $(ECHO_PURPLE_PURPLE_SINGLE "purplePurpleSingle") $(ECHO_PURPLE_PURPLE_GLOW "purplePurpleGlow") $(ECHO_PURPLE_PURPLE_INVERSE "purplePurpleInverse") $(ECHO_PURPLE_PURPLE_DOUBLE "purplePurpleDouble") $(ECHO_PURPLE_CYAN "purpleCyan") $(ECHO_PURPLE_CYAN_BOLD "purpleCyanBold") $(ECHO_PURPLE_CYAN_SINGLE "purpleCyanSingle") $(ECHO_PURPLE_CYAN_GLOW "purpleCyanGlow") $(ECHO_PURPLE_CYAN_INVERSE "purpleCyanInverse") $(ECHO_PURPLE_CYAN_DOUBLE "purpleCyanDouble") $(ECHO_PURPLE_WHITE "purpleWhite") $(ECHO_PURPLE_WHITE_BOLD "purpleWhiteBold") $(ECHO_PURPLE_WHITE_SINGLE "purpleWhiteSingle") $(ECHO_PURPLE_WHITE_GLOW "purpleWhiteGlow") $(ECHO_PURPLE_WHITE_INVERSE "purpleWhiteInverse") $(ECHO_PURPLE_WHITE_DOUBLE "purpleWhiteDouble")"; echo; }
echoMagenta () { echo "💎💎💎💎💎💎💎💎💎💎 Magenta 💎💎💎💎💎💎💎💎💎💎"; echo -n "$(ECHO_MAGENTA "magenta") $(ECHO_MAGENTA_BOLD "magentaBold") $(ECHO_MAGENTA_SINGLE "magentaSingle") $(ECHO_MAGENTA_GLOW "magentaGlow") $(ECHO_MAGENTA_INVERSE "magentaInverse") $(ECHO_MAGENTA_DOUBLE "magentaDouble") $(ECHO_MAGENTA_BLACK "magentaBlack") $(ECHO_MAGENTA_BLACK_BOLD "magentaBlackBold") $(ECHO_MAGENTA_BLACK_SINGLE "magentaBlackSingle") $(ECHO_MAGENTA_BLACK_GLOW "magentaBlackGlow") $(ECHO_MAGENTA_BLACK_INVERSE "magentaBlackInverse") $(ECHO_MAGENTA_BLACK_DOUBLE "magentaBlackDouble") $(ECHO_MAGENTA_RED "magentaRed") $(ECHO_MAGENTA_RED_BOLD "magentaRedBold") $(ECHO_MAGENTA_RED_SINGLE "magentaRedSingle") $(ECHO_MAGENTA_RED_GLOW "magentaRedGlow") $(ECHO_MAGENTA_RED_INVERSE "magentaRedInverse") $(ECHO_MAGENTA_RED_DOUBLE "magentaRedDouble") $(ECHO_MAGENTA_GREEN "magentaGreen") $(ECHO_MAGENTA_GREEN_BOLD "magentaGreenBold") $(ECHO_MAGENTA_GREEN_SINGLE "magentaGreenSingle") $(ECHO_MAGENTA_GREEN_GLOW "magentaGreenGlow") $(ECHO_MAGENTA_GREEN_INVERSE "magentaGreenInverse") $(ECHO_MAGENTA_GREEN_DOUBLE "magentaGreenDouble") $(ECHO_MAGENTA_BROWN "magentaBrown") $(ECHO_MAGENTA_BROWN_BOLD "magentaBrownBold") $(ECHO_MAGENTA_BROWN_SINGLE "magentaBrownSingle") $(ECHO_MAGENTA_BROWN_GLOW "magentaBrownGlow") $(ECHO_MAGENTA_BROWN_INVERSE "magentaBrownInverse") $(ECHO_MAGENTA_BROWN_DOUBLE "magentaBrownDouble") $(ECHO_MAGENTA_PURPLE "magentaPurple") $(ECHO_MAGENTA_PURPLE_BOLD "magentaPurpleBold") $(ECHO_MAGENTA_PURPLE_SINGLE "magentaPurpleSingle") $(ECHO_MAGENTA_PURPLE_GLOW "magentaPurpleGlow") $(ECHO_MAGENTA_PURPLE_INVERSE "magentaPurpleInverse") $(ECHO_MAGENTA_PURPLE_DOUBLE "magentaPurpleDouble") $(ECHO_MAGENTA_PURPLE "magentaPurple") $(ECHO_MAGENTA_PURPLE_BOLD "magentaPurpleBold") $(ECHO_MAGENTA_PURPLE_SINGLE "magentaPurpleSingle") $(ECHO_MAGENTA_PURPLE_GLOW "magentaPurpleGlow") $(ECHO_MAGENTA_PURPLE_INVERSE "magentaPurpleInverse") $(ECHO_MAGENTA_PURPLE_DOUBLE "magentaPurpleDouble") $(ECHO_MAGENTA_CYAN "magentaCyan") $(ECHO_MAGENTA_CYAN_BOLD "magentaCyanBold") $(ECHO_MAGENTA_CYAN_SINGLE "magentaCyanSingle") $(ECHO_MAGENTA_CYAN_GLOW "magentaCyanGlow") $(ECHO_MAGENTA_CYAN_INVERSE "magentaCyanInverse") $(ECHO_MAGENTA_CYAN_DOUBLE "magentaCyanDouble") $(ECHO_MAGENTA_WHITE "magentaWhite") $(ECHO_MAGENTA_WHITE_BOLD "magentaWhiteBold") $(ECHO_MAGENTA_WHITE_SINGLE "magentaWhiteSingle") $(ECHO_MAGENTA_WHITE_GLOW "magentaWhiteGlow") $(ECHO_MAGENTA_WHITE_INVERSE "magentaWhiteInverse") $(ECHO_MAGENTA_WHITE_DOUBLE "magentaWhiteDouble")"; echo; }
echoCyan () { echo "💎💎💎💎💎💎💎💎💎💎    Cyan 💎💎💎💎💎💎💎💎💎💎"; echo -n "$(ECHO_CYAN "cyan") $(ECHO_CYAN_BOLD "cyanBold") $(ECHO_CYAN_SINGLE "cyanSingle") $(ECHO_CYAN_GLOW "cyanGlow") $(ECHO_CYAN_INVERSE "cyanInverse") $(ECHO_CYAN_DOUBLE "cyanDouble") $(ECHO_CYAN_BLACK "cyanBlack") $(ECHO_CYAN_BLACK_BOLD "cyanBlackBold") $(ECHO_CYAN_BLACK_SINGLE "cyanBlackSingle") $(ECHO_CYAN_BLACK_GLOW "cyanBlackGlow") $(ECHO_CYAN_BLACK_INVERSE "cyanBlackInverse") $(ECHO_CYAN_BLACK_DOUBLE "cyanBlackDouble") $(ECHO_CYAN_RED "cyanRed") $(ECHO_CYAN_RED_BOLD "cyanRedBold") $(ECHO_CYAN_RED_SINGLE "cyanRedSingle") $(ECHO_CYAN_RED_GLOW "cyanRedGlow") $(ECHO_CYAN_RED_INVERSE "cyanRedInverse") $(ECHO_CYAN_RED_DOUBLE "cyanRedDouble") $(ECHO_CYAN_GREEN "cyanGreen") $(ECHO_CYAN_GREEN_BOLD "cyanGreenBold") $(ECHO_CYAN_GREEN_SINGLE "cyanGreenSingle") $(ECHO_CYAN_GREEN_GLOW "cyanGreenGlow") $(ECHO_CYAN_GREEN_INVERSE "cyanGreenInverse") $(ECHO_CYAN_GREEN_DOUBLE "cyanGreenDouble") $(ECHO_CYAN_BROWN "cyanBrown") $(ECHO_CYAN_BROWN_BOLD "cyanBrownBold") $(ECHO_CYAN_BROWN_SINGLE "cyanBrownSingle") $(ECHO_CYAN_BROWN_GLOW "cyanBrownGlow") $(ECHO_CYAN_BROWN_INVERSE "cyanBrownInverse") $(ECHO_CYAN_BROWN_DOUBLE "cyanBrownDouble") $(ECHO_CYAN_PURPLE "cyanPurple") $(ECHO_CYAN_PURPLE_BOLD "cyanPurpleBold") $(ECHO_CYAN_PURPLE_SINGLE "cyanPurpleSingle") $(ECHO_CYAN_PURPLE_GLOW "cyanPurpleGlow") $(ECHO_CYAN_PURPLE_INVERSE "cyanPurpleInverse") $(ECHO_CYAN_PURPLE_DOUBLE "cyanPurpleDouble") $(ECHO_CYAN_PURPLE "cyanPurple") $(ECHO_CYAN_PURPLE_BOLD "cyanPurpleBold") $(ECHO_CYAN_PURPLE_SINGLE "cyanPurpleSingle") $(ECHO_CYAN_PURPLE_GLOW "cyanPurpleGlow") $(ECHO_CYAN_PURPLE_INVERSE "cyanPurpleInverse") $(ECHO_CYAN_PURPLE_DOUBLE "cyanPurpleDouble") $(ECHO_CYAN_CYAN "cyanCyan") $(ECHO_CYAN_CYAN_BOLD "cyanCyanBold") $(ECHO_CYAN_CYAN_SINGLE "cyanCyanSingle") $(ECHO_CYAN_CYAN_GLOW "cyanCyanGlow") $(ECHO_CYAN_CYAN_INVERSE "cyanCyanInverse") $(ECHO_CYAN_CYAN_DOUBLE "cyanCyanDouble") $(ECHO_CYAN_WHITE "cyanWhite") $(ECHO_CYAN_WHITE_BOLD "cyanWhiteBold") $(ECHO_CYAN_WHITE_SINGLE "cyanWhiteSingle") $(ECHO_CYAN_WHITE_GLOW "cyanWhiteGlow") $(ECHO_CYAN_WHITE_INVERSE "cyanWhiteInverse") $(ECHO_CYAN_WHITE_DOUBLE "cyanWhiteDouble")"; echo; }
echoWhite () { echo "💎💎💎💎💎💎💎💎💎💎   White 💎💎💎💎💎💎💎💎💎💎"; echo -n "$(ECHO_WHITE "white") $(ECHO_WHITE_BOLD "whiteBold") $(ECHO_WHITE_SINGLE "whiteSingle") $(ECHO_WHITE_GLOW "whiteGlow") $(ECHO_WHITE_INVERSE "whiteInverse") $(ECHO_WHITE_DOUBLE "whiteDouble") $(ECHO_WHITE_BLACK "whiteBlack") $(ECHO_WHITE_BLACK_BOLD "whiteBlackBold") $(ECHO_WHITE_BLACK_SINGLE "whiteBlackSingle") $(ECHO_WHITE_BLACK_GLOW "whiteBlackGlow") $(ECHO_WHITE_BLACK_INVERSE "whiteBlackInverse") $(ECHO_WHITE_BLACK_DOUBLE "whiteBlackDouble") $(ECHO_WHITE_RED "whiteRed") $(ECHO_WHITE_RED_BOLD "whiteRedBold") $(ECHO_WHITE_RED_SINGLE "whiteRedSingle") $(ECHO_WHITE_RED_GLOW "whiteRedGlow") $(ECHO_WHITE_RED_INVERSE "whiteRedInverse") $(ECHO_WHITE_RED_DOUBLE "whiteRedDouble") $(ECHO_WHITE_GREEN "whiteGreen") $(ECHO_WHITE_GREEN_BOLD "whiteGreenBold") $(ECHO_WHITE_GREEN_SINGLE "whiteGreenSingle") $(ECHO_WHITE_GREEN_GLOW "whiteGreenGlow") $(ECHO_WHITE_GREEN_INVERSE "whiteGreenInverse") $(ECHO_WHITE_GREEN_DOUBLE "whiteGreenDouble") $(ECHO_WHITE_BROWN "whiteBrown") $(ECHO_WHITE_BROWN_BOLD "whiteBrownBold") $(ECHO_WHITE_BROWN_SINGLE "whiteBrownSingle") $(ECHO_WHITE_BROWN_GLOW "whiteBrownGlow") $(ECHO_WHITE_BROWN_INVERSE "whiteBrownInverse") $(ECHO_WHITE_BROWN_DOUBLE "whiteBrownDouble") $(ECHO_WHITE_PURPLE "whitePurple") $(ECHO_WHITE_PURPLE_BOLD "whitePurpleBold") $(ECHO_WHITE_PURPLE_SINGLE "whitePurpleSingle") $(ECHO_WHITE_PURPLE_GLOW "whitePurpleGlow") $(ECHO_WHITE_PURPLE_INVERSE "whitePurpleInverse") $(ECHO_WHITE_PURPLE_DOUBLE "whitePurpleDouble") $(ECHO_WHITE_PURPLE "whitePurple") $(ECHO_WHITE_PURPLE_BOLD "whitePurpleBold") $(ECHO_WHITE_PURPLE_SINGLE "whitePurpleSingle") $(ECHO_WHITE_PURPLE_GLOW "whitePurpleGlow") $(ECHO_WHITE_PURPLE_INVERSE "whitePurpleInverse") $(ECHO_WHITE_PURPLE_DOUBLE "whitePurpleDouble") $(ECHO_WHITE_CYAN "whiteCyan") $(ECHO_WHITE_CYAN_BOLD "whiteCyanBold") $(ECHO_WHITE_CYAN_SINGLE "whiteCyanSingle") $(ECHO_WHITE_CYAN_GLOW "whiteCyanGlow") $(ECHO_WHITE_CYAN_INVERSE "whiteCyanInverse") $(ECHO_WHITE_CYAN_DOUBLE "whiteCyanDouble") $(ECHO_WHITE_WHITE "whiteWhite") $(ECHO_WHITE_WHITE_BOLD "whiteWhiteBold") $(ECHO_WHITE_WHITE_SINGLE "whiteWhiteSingle") $(ECHO_WHITE_WHITE_GLOW "whiteWhiteGlow") $(ECHO_WHITE_WHITE_INVERSE "whiteWhiteInverse") $(ECHO_WHITE_WHITE_DOUBLE "whiteWhiteDouble")"; echo; }

echoBlack
echoRed
echoGreen
echoYellow
echoPurple
echoMagenta
echoCyan
echoWhite
echo "✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨"
colors=("Black" "Red" "Green" "Yellow" "Purple" "Magenta" "Cyan" "White")
colors_length=${#colors[@]}
for ((c = 1; c <= ${#colors[@]}; c += 1)); do
  echo "$c ${colors[c-1]}"
done

echo -n "Select Color[1~$(expr $colors_length)]: "
read selectedColor

if [ ${selectedColor} -gt ${colors_length} ]; then
  ECHO_RED_DOUBLE "Selected Color(${selectedColor}) is greather than ${colors_length}."
  exit
fi
if [ ${selectedColor} -le 0 ]; then
  ECHO_PURPLE_DOUBLE "Selected Color(${selectedColor}) is less than 0."
  exit
fi

clear
colorIndex=$(expr ${selectedColor} - 1)
color=${colors[colorIndex]}
func="echo${color}"

echo "$($func | tr ' ' '\n' | sed '/^$/d')" > $tempfile1
echo -n $(cat $tempfile1 | head -3)
echo

lines=$(cat $tempfile1 | wc -l)
tail=$(expr $lines - 3)
echo "$(cat $tempfile1 | tail -$tail)" > $tempfile2
cat -n $tempfile2
functions_length=$(cat $tempfile2 | wc -l)
echo "functions_length is ${functions_length}"

echo -n "Select Function[1~$functions_length]: "
read selectedFunction

if [ ${selectedFunction} -gt ${functions_length} ]; then
  ECHO_RED_DOUBLE "Selected Function(${selectedFunction}) is greather than ${functions_length}."
  exit
fi
if [ ${selectedFunction} -le 0 ]; then
  ECHO_PURPLE_DOUBLE "Selected Function(${selectedFunction}) is less than 0."
  exit
fi

clear

function_dirty=$(echo -e $(cat $tempfile2 | head -$selectedFunction | tail -1))

to_snake_case=$(echo "$function_dirty" | sed 's/\([a-z]\)\([A-Z]\)/\1_\2/g')
extract_alpha_underscore=$(echo "$to_snake_case" | tr -cd '[:alpha:]_')
strip=$(echo $extract_alpha_underscore | awk '{print substr($0, 2, length($0)-2)}')
to_CONSTANT_CASE=$(echo $strip | tr '[:lower:]' '[:upper:]')

function_name="ECHO_$to_CONSTANT_CASE"
echo "✅ $function_name"
echo -n "Enter Message: "
read message
$function_name "$message ✨"

rm $tempfile1
rm $tempfile2

exit