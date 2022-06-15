start /b /wait julia ../specializedModelCheckerTest.jl
start /b /wait julia modelCheckerTestGeneralNoCache.jl
start /b /wait julia modelCheckerTestSpecializedCached.jl
start /b /wait julia modelCheckerTestSpecializedNoCache.jl
start /b /wait julia modelCheckerTestSpecializedNoCacheBackwardsIt.jl
start /b /wait julia modelCheckerTestSpecializedTopFormulaCached.jl