; ============================================================
; Inno Setup Script for Flutter Desktop Application
; ============================================================

#ifndef AppName
  #define AppName "Tạo bill thuốc"
#endif

#ifndef AppSlug
  #define AppSlug "drugs-maker"
#endif

#ifndef AppExe
  #define AppExe "drugs_maker.exe"
#endif

#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif

#ifndef ReleaseVersion
  #define ReleaseVersion "v1.0"
#endif

#ifndef AppPublisher
  #define AppPublisher "Nguyễn Duy Trường"
#endif

#ifndef AppURL
  #define AppURL "https://github.com/skul9x/MakeBilllDrugs"
#endif

[Setup]
AppId={{E5B1A832-73A4-4A23-997E-4819F30D8BC4}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#ReleaseVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={autopf}\{#AppName}
DisableProgramGroupPage=yes
OutputBaseFilename={#AppSlug}-{#ReleaseVersion}-windows-x64-setup
OutputDir=.
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible
ArchitecturesAllowed=x64compatible
UninstallDisplayIcon={app}\{#AppExe}
SetupIconFile=windows\runner\resources\app_icon.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
