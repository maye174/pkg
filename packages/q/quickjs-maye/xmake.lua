package("quickjs-maye")

    set_homepage("https://bellard.org/quickjs/")
    set_description("QuickJS is a small and embeddable Javascript engine")

    add_urls("https://github.com/maye174/quickjs.git")
    add_versions("2021.03.27", "40b1e603fda8d46680a39f48d6e8a92f154a5f6e1e5ada429d139f6f00d59571")

    if is_plat("linux", "macosx", "iphoneos", "cross") then
        add_syslinks("pthread", "dl", "m")
    elseif is_plat("android") then
        add_syslinks("dl", "m")
    end
    
    on_install("linux", "macosx", "iphoneos", "android", "mingw", "cross", "windows", function (package)
        io.writefile("xmake.lua", ([[
            add_rules("mode.debug", "mode.release")
            target("quickjs-maye")
                set_kind("$(kind)")
                add_files("src/quickjs*.c", "src/cutils.c", "src/lib*.c")
                add_headerfiles("src/quickjs-libc.h")
                add_headerfiles("src/quickjs.h")
                add_installfiles("src/*.js", {prefixdir = "share"})
                set_languages("c99")
                add_defines("CONFIG_VERSION=\"%s\"", "_GNU_SOURCE")
                add_defines("CONFIG_BIGNUM")
                if is_plat("windows") then
                    add_defines("_MSC_VER")
                end
                if is_plat("mingw") then
                    add_defines("__USE_MINGW_ANSI_STDIO")
                end
        ]]):format(package:version_str()))
        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end
        if package:is_plat("cross") then
            io.replace("src/quickjs.c", "#define CONFIG_PRINTF_RNDN", "")
        end
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_install("windows", function (package)
    --     local configs = {}
    --     if package:config("shared") then
    --         configs.kind = "shared"
    --     end
    --     import("package.tools.xmake").install(package, configs)
    -- end)

    on_test(function (package)
        assert(package:has_cfuncs("JS_NewRuntime", {includes = "src/quickjs.h"}))
    end)