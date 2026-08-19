; ============================================================
; NSIS Installer Script for Drugs Maker Flutter
; Usage: makensis installer.nsi
; Requires: NSIS 3.x  (negrutiu build recommended for amd64)
;
; Flutter Windows build output path (current Flutter):
;   build\windows\x64\runner\Release\
; ============================================================

!define APP_NAME      "Tạo bill thuốc"
!define APP_EXE       "drugs_maker.exe"
!define APP_PUBLISHER "Nguyễn Duy Trường"
!define APP_URL       "https://github.com/skul9x/MakeBilllDrugs"
!define INSTALL_DIR   "$PROGRAMFILES64\Tạo bill thuốc"
!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\DrugsMaker"

; Version được ghi bởi CI vào file version.nsh
; Ví dụ nội dung:  !define VERSION "1.2"
!include "version.nsh"

Name    "${APP_NAME} ${VERSION}"
OutFile "drugs-maker-flutter-${VERSION}-setup.exe"
InstallDir "${INSTALL_DIR}"
InstallDirRegKey HKLM "${UNINSTALL_KEY}" "InstallLocation"
RequestExecutionLevel admin
SetCompressor /SOLID lzma
Unicode true

; ── Modern UI ────────────────────────────────────────────────
!include "MUI2.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON   "windows\runner\resources\app_icon.ico"
!define MUI_UNICON "windows\runner\resources\app_icon.ico"

!define MUI_WELCOMEPAGE_TITLE \
  "Chào mừng đến với trình cài đặt ${APP_NAME}"
!define MUI_WELCOMEPAGE_TEXT \
  "Trình cài đặt sẽ hướng dẫn bạn cài đặt ${APP_NAME} ${VERSION}.$\n$\nKhuyến nghị đóng tất cả ứng dụng đang chạy trước khi tiếp tục."
!define MUI_FINISHPAGE_TITLE "Cài đặt hoàn tất!"
!define MUI_FINISHPAGE_TEXT \
  "${APP_NAME} ${VERSION} đã được cài đặt thành công.$\n$\nNhấn Hoàn tất để đóng trình cài đặt."
!define MUI_FINISHPAGE_RUN          "$INSTDIR\${APP_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT     "Khởi chạy ${APP_NAME}"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "Vietnamese"
!insertmacro MUI_LANGUAGE "English"

; ── Install Section ──────────────────────────────────────────
Section "Main Application" SecMain
  SectionIn RO
  SetOutPath "$INSTDIR"

  ; ⚠️  Flutter Windows build output: build\windows\x64\runner\Release\
  ;     Bao gồm .exe, .dll và thư mục data
  File /r "build\windows\x64\runner\Release\*.*"

  ; Start Menu shortcuts
  CreateDirectory "$SMPROGRAMS\${APP_NAME}"
  CreateShortcut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" \
    "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}"
  CreateShortcut "$SMPROGRAMS\${APP_NAME}\Gỡ cài đặt.lnk" \
    "$INSTDIR\Uninstall.exe"

  ; Desktop shortcut
  CreateShortcut "$DESKTOP\${APP_NAME}.lnk" \
    "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}"

  ; Write uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Add/Remove Programs registry entries
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "DisplayName"     "${APP_NAME}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "DisplayVersion"  "${VERSION}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "Publisher"       "${APP_PUBLISHER}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "URLInfoAbout"    "${APP_URL}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoModify"        1
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoRepair"        1
SectionEnd

; ── Uninstall Section ────────────────────────────────────────
Section "Uninstall"
  ; Remove installed files & dirs
  RMDir /r "$INSTDIR"

  ; Remove Start Menu shortcuts
  RMDir /r "$SMPROGRAMS\${APP_NAME}"

  ; Remove Desktop shortcut
  Delete "$DESKTOP\${APP_NAME}.lnk"

  ; Remove registry entries
  DeleteRegKey HKLM "${UNINSTALL_KEY}"
SectionEnd
