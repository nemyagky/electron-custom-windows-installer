!include MUI2.nsh

!define UNINST_PATH "$Temp\Installer Demo"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Installer Demo"


!define MUI_WELCOMEPAGE_TITLE  "Welcome to Installer Demo application"
!define MUI_WELCOMEPAGE_TEXT  "MUI is used to customize texts in this installer $\r$\n $\r$\n You can find docs here if necessary https://nsis.sourceforge.io/Docs/Modern%20UI%202/Readme.html. It's easy to understand $\r$\n $\r$\n Click Next to continue."

!define MUI_PAGE_HEADER_TEXT "You can also customize title"
!define MUI_PAGE_HEADER_SUBTEXT "And this subheader"
!define MUI_LICENSEPAGE_TEXT_TOP  "Read and accept our EULA"
!define MUI_LICENSEPAGE_TEXT_BOTTOM  "You can simply add checkbox/radio here using MUI_LICENSEPAGE_CHECKBOX"
!define MUI_LICENSEPAGE_BUTTON  "Next"


!define MUI_DIRECTORYPAGE_TEXT_TOP "Here you can choose application location"
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "You can disable this screen via disabling allowToChangeInstallationDirectory in package.json"

!define MUI_FINISHPAGE_TITLE  "Thank you for installation"
!define MUI_FINISHPAGE_TEXT  "In general, you can customize color, sizes, etc. I'm not sure is it able to disable run application button, but it's allowed to run any script after installing. E.g. to launch application $\r$\n $\r$\n Click Close to finish installation"
!define MUI_FINISHPAGE_RUN_TEXT "Run application"
!define MUI_FINISHPAGE_BUTTON  "Close"

!define MUI_UNABORTWARNING_TEXT  "You trying to close me?))))"

!ifndef BUILD_UNINSTALLER
Function IsProductInstalled
  ClearErrors
  ReadRegStr $2 "${PRODUCT_UNINST_ROOT_KEY}" "${PRODUCT_UNINST_KEY}" "UninstallString"
  StrCmp $2 "" 0 jump_to_if_not_equal
    goto end
  jump_to_if_not_equal:
    MessageBox MB_YESNO "Application Already Installed. You still want to continue?" IDYES true IDNO false
    true:
      Goto next
    false:
        Quit
    next:
  end:
FunctionEnd
!endif


Section
  SetShellVarContext current
  WriteUninstaller "${UNINST_PATH}\Uninstaller.exe"
  WriteRegStr "${PRODUCT_UNINST_ROOT_KEY}" "${PRODUCT_UNINST_KEY}" "UninstallString" "$(^Name)"

  CreateDirectory "$Desktop\foldername"
  CreateShortcut "$Desktop\foldername\$(^Name).lnk" "$InstDir\Installer Demo.exe"
SectionEnd

Section Uninstall
  DeleteRegKey "${PRODUCT_UNINST_ROOT_KEY}" "${PRODUCT_UNINST_KEY}"
SectionEnd

!macro customWelcomePage
    !insertMacro MUI_PAGE_WELCOME
!macroend

!macro customInit
    Call IsProductInstalled
!macroend
