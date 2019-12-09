# This file contains the list of servers you want to copy files/folders to
$computers = Get-Content "c:\scripts\computers1.txt"
 
# This is the KB/folder(s) you want to copy to the servers in the $computer variable
$Win764bitPatch = "\\Path\KB\Windows7x64"
$Win732bitPatch = "\\Path\KB\Windows7x32"
$Win864bitPatch = "\\Path\KB\Windows8x64"
#$Win832bitPatch = "\\Path\KB\Windows8x32"
$Windows10_14393 = "\\Path\KB\windows10x64"
$windows10_1511 = "\\Path\KB\Windows7x64"
$windows10_1507 = "\\Path\KB\Windows7x64"

# The destination location you want the file/folder(s) to be copied to
$destination = "C$\IT\"

#The command below pulls all the variables above and performs the file copy
ForEach ($computer in $computers) {

  if (Test-Connection -ComputerName $Computer -Count 1 -Quiet )

  {

    write-Host "$computer is Up" -ForegroundColor Green 

	Write-Host "Processing $($Computer) ..." -ForegroundColor Green
	
If (!(Get-HotFix -ComputerName $computer -Id KB4012212, KB4012215, KB4015549, KB4019264, KB4022719, KB4025337, KB4025341, KB4012213, KB4012216, KB4015550, KB4019215, KB4022726, KB4025336, KB4013198, KB4015219, KB4019473, KB4025344, KB4015438, KB4015217, KB4019472, KB4025339, KB4025342 -ErrorAction SilentlyContinue)){
    $OS = Get-WmiObject -Query "select * from Win32_OperatingSystem" -ComputerName $Computer
    Write-Output $OS | Select-Object PSComputerName, Caption, OSArchitecture, BuildNumber

	If (($OS.Caption -like '*Windows 7*') -and ($OS.OSArchitecture -eq '64-bit')) {

		if ($x = Copy-Item $Win764bitPatch -Destination "\\$computer\$destination\" -Force -Recurse -PassThru)
                {

                   write-Host "Copied $Win764bitPatch to \\$computer\$destination" -ForegroundColor Green
                    .\PsExec.exe \\$computer dism.exe /online /add-package /PackagePath:C:\IT\Windows6.1-KB4025341-x64.cab /NoRestart
		         
                }

		<# If (0, 3010 -contains $LASTEXITCODE) {
			Write-Host " OK." -ForegroundColor Green
		} Else {
			Write-Host " FAILED." -ForegroundColor Red
		} #>


	} #endif$OS

       ElseIf (($OS.Caption -like '*Windows 7*') -and ($OS.OSArchitecture -eq '32-bit'))

            {

               if ($x = Copy-Item $Win732bitPatch -Destination "\\$computer\$destination" -Recurse -PassThru -ErrorAction silentlyContinue)

               {

                 write-Host "Copied $Win764bitPatch to \\$computer\$destination" -ForegroundColor Green
                 
                .\PsExec.exe -s \\$computer wusa.exe "c:\WIN732windows6.1-kb4012212-x86.msu" /quiet

                }


            }
                    
       ElseIf (($OS.Caption -like '*Windows 8*') -and ($OS.OSArchitecture -eq '64-bit'))

            {

               if ($x = Copy-Item $Win864bitPatch -Destination "\\$computer\$destination" -Force -Recurse -PassThru -ErrorAction silentlyContinue)

               {

                 write-Host "Copied $ to \\$computer\$destination" -ForegroundColor Green
                
                .\PsExec.exe \\$computer dism.exe /online /add-package /PackagePath:C:\IT\Windows8.1-KB4025336-x64.cab /NoRestart 
                
                }


	        }


        Elseif (($OS.Caption -like '*Windows 10*') -and ($OS.BuildNumber -eq '14393'))

            {

              

                    if ($x = Copy-Item $Windows10_14393 -Destination "\\$computer\$destination" -Recurse -PassThru -ErrorAction silentlyContinue)

                    {

                    write-Host "Copied $Windows10_14393 to \\$computer\$destination" -ForegroundColor Green

                    .\PsExec.exe \\$computer dism.exe /online /add-package /PackagePath:C:\IT\Windows10.0-KB4025339-x64.cab /NoRestart
                    #.\PsExec.exe -s \\$computer wusa.exe "c:\$(($Windows10_14393 -split "\\")[-1])" /quiet

                    }

             }
           
          Elseif (($OS.Caption -like '*Windows 10*') -and ($OS.BuildNumber -eq '1511'))

                    {

                       if ($x = Copy-Item $windows10_1511 -Destination "\\$computer\$destination" -Recurse -PassThru -ErrorAction silentlyContinue )

                       {

                         write-Host "Copied $Windows10_14393 to \\$computer\$destination" -ForegroundColor Green

                        .\PsExec.exe -s \\$computer wusa.exe "c:\$(($windows10_1511 -split "\\")[-1])" /quiet

                        }

                    }


           Elseif (($OS.Caption -like '*Windows 10*') -and ($OS.BuildNumber -eq '1507'))

                 
                    {

                        if ($x=Copy-Item $windows10_1507 -Destination "\\$computer\$destination" -Recurse -PassThru -ErrorAction silentlyContinue)

                        {

                         write-Host "Copied $Windows10_14393 to \\$computer\$destination" -ForegroundColor Green

                        .\PsExec.exe -s \\$computer wusa.exe "c:\$(($windows10_1507 -split "\\")[-1])" /quiet

                        }

                    }

             Elseif (($OS.Caption -like '*Windows 10*') -and ($OS.BuildNumber -eq '10586'))


                    {

                       if ($x = Copy-Item $windows10_1511 -Destination "\\$computer\$destination" -Recurse -PassThru -ErrorAction silentlyContinue)

                       {

                         write-Host "Copied $Windows10_14393 to \\$computer\$destination" -ForegroundColor Green

                        .\PsExec.exe -s \\$computer wusa.exe "c:\$(($windows10_1511 -split "\\")[-1])" /quiet


                       }

                    }

            }#endifhotfix
                Else { Write-Host "Patch Already Exists on $Computer" -ForegroundColor Yellow
                
                        } 

            }#endiftestconnection  
             Else {
                         Write-Host "Could not Connect to $Computer, Please try again later." -ForegroundColor Red 

                            }

}#EndForeach
