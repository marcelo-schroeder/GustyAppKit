#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

realpath() {
  DIRECTORY="$(cd "${1%/*}" && pwd)"
  FILENAME="${1##*/}"
  echo "$DIRECTORY/$FILENAME"
}

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE=$(realpath "${PODS_ROOT}/$1")
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/056-PlusCircle.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/056-PlusCircle@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/191-ArrowHead-left.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/191-ArrowHead-left@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/191-ArrowHead-right.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/191-ArrowHead-right@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/248-QuestionCircleAlt.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/248-QuestionCircleAlt@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/248-QuestionCircleAlt_black.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/248-QuestionCircleAlt_black@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/271-ThreeColumn.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/271-ThreeColumn@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/277-MultiplyCircle-black.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/277-MultiplyCircle-black@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/277-MultiplyCircle-white.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/277-MultiplyCircle-white@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/310-RemoveButton.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/310-RemoveButton@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/License.rtf"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAEntityConfig.plist"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAFormInputAccessoryContentView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAFormSectionFooterContentView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAFormSectionHeaderView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAFormTableViewCellContentView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAHtmlTemplate.txt"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAMapSettingsViewController.storyboard"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAMultipleSelectionListViewCell.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFASingleSelectionListViewControllerHeaderView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFATableSectionHeaderView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineHorizontalBottom.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineHorizontalBottom@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineHorizontalTop.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineHorizontalTop@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineVerticalLeft.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineVerticalLeft@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineVerticalRight.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineVerticalRight@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Add.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_AddToSelection.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_AddToSelection@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Close.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Close@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_ICon_Delete.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_ICon_Delete@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_DisclosureIndicatorDown.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_DisclosureIndicatorDown@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_DisclosureIndicatorRight.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_DisclosureIndicatorRight@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudError.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudError@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudError@3x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudSuccess.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudSuccess@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudSuccess@3x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Info.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Info@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_List.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_List@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Next.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Next@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Previous.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Previous@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_RemoveFromSelection.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_RemoveFromSelection@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_UserLocation.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_UserLocation@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_TextViewBorder.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_TextViewBorder@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFA_Icon_Help_normal.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFA_Icon_Help_normal@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFA_Icon_Help_selected.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFA_Icon_Help_selected@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFAHelpViewControllerWebView.css"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/056-PlusCircle.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/056-PlusCircle@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/191-ArrowHead-left.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/191-ArrowHead-left@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/191-ArrowHead-right.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/191-ArrowHead-right@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/248-QuestionCircleAlt.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/248-QuestionCircleAlt@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/248-QuestionCircleAlt_black.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/248-QuestionCircleAlt_black@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/271-ThreeColumn.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/271-ThreeColumn@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/277-MultiplyCircle-black.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/277-MultiplyCircle-black@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/277-MultiplyCircle-white.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/277-MultiplyCircle-white@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/310-RemoveButton.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/310-RemoveButton@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net/License.rtf"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAEntityConfig.plist"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAFormInputAccessoryContentView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAFormSectionFooterContentView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAFormSectionHeaderView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAFormTableViewCellContentView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAHtmlTemplate.txt"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAMapSettingsViewController.storyboard"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFAMultipleSelectionListViewCell.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFASingleSelectionListViewControllerHeaderView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/IFATableSectionHeaderView.xib"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineHorizontalBottom.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineHorizontalBottom@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineHorizontalTop.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineHorizontalTop@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineVerticalLeft.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineVerticalLeft@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineVerticalRight.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_1PixelLineVerticalRight@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Add.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_AddToSelection.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_AddToSelection@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Close.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Close@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_ICon_Delete.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_ICon_Delete@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_DisclosureIndicatorDown.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_DisclosureIndicatorDown@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_DisclosureIndicatorRight.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_DisclosureIndicatorRight@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudError.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudError@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudError@3x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudSuccess.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudSuccess@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_HudSuccess@3x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Info.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Info@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_List.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_List@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Next.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Next@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Previous.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_Previous@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_RemoveFromSelection.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_RemoveFromSelection@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_UserLocation.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_Icon_UserLocation@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_TextViewBorder.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/images/IFA_TextViewBorder@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/CoreUI/resources/3rd party/billybarker.net"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFA_Icon_Help_normal.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFA_Icon_Help_normal@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFA_Icon_Help_selected.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFA_Icon_Help_selected@2x.png"
  install_resource "../../../GustyKit/GustyKit_development/GustyKit/GustyKit/Help/resources/IFAHelpViewControllerWebView.css"
fi

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac

  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "`realpath $PODS_ROOT`*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
