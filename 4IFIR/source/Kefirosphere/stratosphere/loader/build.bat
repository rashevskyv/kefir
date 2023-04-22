make -j12
xcopy ".\out\nintendo_nx_arm64_armv8a\release\loader.kip" ".\" /H /Y /C /R /S
.\hactool.exe -t kip1 loader.kip --uncompress=.\loader.kip