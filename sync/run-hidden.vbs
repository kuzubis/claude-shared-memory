' Runs sync.ps1 without a window (so nothing flashes every 30 min).
' Arguments are passed through: run-hidden.vbs <WorkFolder> [DriveCopyName] [DriveFolder]
' Empty arguments are skipped: Windows PowerShell 5.1 rejects "-Param """ with "Missing an argument".
Set args = WScript.Arguments
Set fso = CreateObject("Scripting.FileSystemObject")
script = fso.GetParentFolderName(WScript.ScriptFullName) & "\sync.ps1"
cmd = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & script & """"
names = Array("-WorkFolder", "-DriveCopyName", "-DriveFolder")
For i = 0 To args.Count - 1
    If i <= UBound(names) Then
        If Len(args(i)) > 0 Then cmd = cmd & " " & names(i) & " """ & args(i) & """"
    End If
Next
CreateObject("WScript.Shell").Run cmd, 0, False
