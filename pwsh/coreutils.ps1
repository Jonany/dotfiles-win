try {
    coreutils --help > $null

    #function coreutils-arch { coreutils arch @args }
    #function coreutils-b2sum { coreutils b2sum @args }
    #function coreutils-b3sum { coreutils b3sum @args }
    #function coreutils-base32 { coreutils base32 @args }
    #function coreutils-base64 { coreutils base64 @args }
    #function coreutils-basename { coreutils basename @args }
    #function coreutils-basenc { coreutils basenc @args }
    function coreutils-cat { coreutils cat @args }
    #function coreutils-cksum { coreutils cksum @args }
    #function coreutils-comm { coreutils comm @args }
    #function coreutils-cp { coreutils cp @args } # Reserved keyword/alias
    #function coreutils-csplit { coreutils csplit @args }
    #function coreutils-cut { coreutils cut @args }
    function coreutils-date { coreutils date @args }
    #function coreutils-dd { coreutils dd @args }
    function coreutils-df { coreutils df @args }
    #function coreutils-dir { coreutils dir @args } # Reserved keyword/alias
    #function coreutils-dircolors { coreutils dircolors @args }
    #function coreutils-dirname { coreutils dirname @args }
    function coreutils-du { coreutils du @args }
    #function coreutils-echo { coreutils echo @args } # Reserved keyword/alias
    #function coreutils-env { coreutils env @args }
    #function coreutils-expand { coreutils expand @args }
    #function coreutils-expr { coreutils expr @args }
    #function coreutils-factor { coreutils factor @args }
    #function coreutils-false { coreutils false @args }
    #function coreutils-fmt { coreutils fmt @args }
    #function coreutils-fold { coreutils fold @args }
    #function coreutils-hashsum { coreutils hashsum @args }
    function coreutils-head { coreutils head @args }
    #function coreutils-hostname { coreutils hostname @args }
    #function coreutils-join { coreutils join @args }
    #function coreutils-link { coreutils link @args }
    #function coreutils-ln { coreutils ln @args }
    #function coreutils-ls { coreutils ls @args } # Prefering lsd over this
    #function coreutils-md5sum { coreutils md5sum @args }
    function coreutils-mkdir { coreutils mkdir @args }
    #function coreutils-mktemp { coreutils mktemp @args }
    #function coreutils-more { coreutils more @args }
    function coreutils-mv { coreutils mv @args }
    #function coreutils-nl { coreutils nl @args }
    #function coreutils-nproc { coreutils nproc @args }
    #function coreutils-numfmt { coreutils numfmt @args }
    #function coreutils-od { coreutils od @args }
    #function coreutils-paste { coreutils paste @args }
    #function coreutils-pr { coreutils pr @args }
    #function coreutils-printenv { coreutils printenv @args }
    #function coreutils-printf { coreutils printf @args }
    #function coreutils-ptx { coreutils ptx @args }
    function coreutils-pwd { coreutils pwd @args }
    #function coreutils-readlink { coreutils readlink @args }
    #function coreutils-realpath { coreutils realpath @args }
    function coreutils-rm { coreutils rm @args }
    #function coreutils-rmdir { coreutils rmdir @args }
    #function coreutils-seq { coreutils seq @args }
    #function coreutils-sha1sum { coreutils sha1sum @args }
    #function coreutils-sha224sum { coreutils sha224sum @args }
    #function coreutils-sha256sum { coreutils sha256sum @args }
    #function coreutils-sha3-224sum { coreutils sha3-224sum @args }
    #function coreutils-sha3-256sum { coreutils sha3-256sum @args }
    #function coreutils-sha3-384sum { coreutils sha3-384sum @args }
    #function coreutils-sha3-512sum { coreutils sha3-512sum @args }
    #function coreutils-sha384sum { coreutils sha384sum @args }
    #function coreutils-sha3sum { coreutils sha3sum @args }
    #function coreutils-sha512sum { coreutils sha512sum @args }
    #function coreutils-shake128sum { coreutils shake128sum @args }
    #function coreutils-shake256sum { coreutils shake256sum @args }
    #function coreutils-shred { coreutils shred @args }
    #function coreutils-shuf { coreutils shuf @args }
    #function coreutils-sleep { coreutils sleep @args } # Reserved keyword/alias
    #function coreutils-sort { coreutils sort @args } # Reserved keyword/alias
    function coreutils-split { coreutils split @args }
    #function coreutils-sum { coreutils sum @args }
    #function coreutils-sync { coreutils sync @args }
    #function coreutils-tac { coreutils tac @args }
    function coreutils-tail { coreutils tail @args }
    #function coreutils-tee { coreutils tee @args } # Reserved keyword/alias
    #function coreutils-test { coreutils test @args }
    function coreutils-touch { coreutils touch @args }
    #function coreutils-tr { coreutils tr @args }
    function coreutils-true { coreutils true @args }
    #function coreutils-truncate { coreutils truncate @args }
    #function coreutils-tsort { coreutils tsort @args }
    #function coreutils-uname { coreutils uname @args }
    #function coreutils-unexpand { coreutils unexpand @args }
    #function coreutils-uniq { coreutils uniq @args }
    #function coreutils-unlink { coreutils unlink @args }
    #function coreutils-vdir { coreutils vdir @args }
    #function coreutils-wc { coreutils wc @args }
    function coreutils-whoami { coreutils whoami @args }
    #function coreutils-yes { coreutils yes @args }

    # 2025-09-19: Switching to an "enable as needed approach" which will hopefully speed shell loads times.
    #Set-Alias -Name arch        -Value coreutils-arch
    #Set-Alias -Name b2sum       -Value coreutils-b2sum
    #Set-Alias -Name b3sum       -Value coreutils-b3sum
    #Set-Alias -Name base32      -Value coreutils-base32
    #Set-Alias -Name base64      -Value coreutils-base64
    #Set-Alias -Name basename    -Value coreutils-basename
    #Set-Alias -Name basenc      -Value coreutils-basenc
    Set-Alias -Name cat         -Value coreutils-cat
    #Set-Alias -Name cksum       -Value coreutils-cksum
    #Set-Alias -Name comm        -Value coreutils-comm
    #Set-Alias -Name cp          -Value coreutils-cp # Reserved keyword/alias
    #Set-Alias -Name csplit      -Value coreutils-csplit
    #Set-Alias -Name cut         -Value coreutils-cut
    Set-Alias -Name date        -Value coreutils-date
    #Set-Alias -Name dd          -Value coreutils-dd
    Set-Alias -Name df          -Value coreutils-df
    #Set-Alias -Name dir         -Value coreutils-dir # Reserved keyword/alias
    #Set-Alias -Name dircolors   -Value coreutils-dircolors
    #Set-Alias -Name dirname     -Value coreutils-dirname
    Set-Alias -Name du          -Value coreutils-du
    #Set-Alias -Name echo        -Value coreutils-echo # Reserved keyword/alias
    #Set-Alias -Name env         -Value coreutils-env
    #Set-Alias -Name expand      -Value coreutils-expand
    #Set-Alias -Name expr        -Value coreutils-expr
    #Set-Alias -Name factor      -Value coreutils-factor
    #Set-Alias -Name false       -Value coreutils-false
    #Set-Alias -Name fmt         -Value coreutils-fmt
    #Set-Alias -Name fold        -Value coreutils-fold
    #Set-Alias -Name hashsum     -Value coreutils-hashsum
    Set-Alias -Name head        -Value coreutils-head
    #Set-Alias -Name hostname    -Value coreutils-hostname
    #Set-Alias -Name join        -Value coreutils-join
    #Set-Alias -Name link        -Value coreutils-link
    #Set-Alias -Name ln          -Value coreutils-ln
    #Set-Alias -Name ls          -Value coreutils-ls
    #Set-Alias -Name md5sum      -Value coreutils-md5sum
    Set-Alias -Name mkdir       -Value coreutils-mkdir
    #Set-Alias -Name mktemp      -Value coreutils-mktemp
    #Set-Alias -Name more        -Value coreutils-more
    Set-Alias -Name mv          -Value coreutils-mv
    #Set-Alias -Name nl          -Value coreutils-nl
    #Set-Alias -Name nproc       -Value coreutils-nproc
    #Set-Alias -Name numfmt      -Value coreutils-numfmt
    #Set-Alias -Name od          -Value coreutils-od
    #Set-Alias -Name paste       -Value coreutils-paste
    #Set-Alias -Name pr          -Value coreutils-pr
    #Set-Alias -Name printenv    -Value coreutils-printenv
    #Set-Alias -Name printf      -Value coreutils-printf
    #Set-Alias -Name ptx         -Value coreutils-ptx
    Set-Alias -Name pwd         -Value coreutils-pwd
    #Set-Alias -Name readlink    -Value coreutils-readlink
    #Set-Alias -Name realpath    -Value coreutils-realpath
    Set-Alias -Name rm          -Value coreutils-rm
    #Set-Alias -Name rmdir       -Value coreutils-rmdir
    #Set-Alias -Name seq         -Value coreutils-seq
    #Set-Alias -Name sha1sum     -Value coreutils-sha1sum
    #Set-Alias -Name sha224sum   -Value coreutils-sha224sum
    #Set-Alias -Name sha256sum   -Value coreutils-sha256sum
    #Set-Alias -Name sha3-224sum -Value coreutils-sha3-224sum
    #Set-Alias -Name sha3-256sum -Value coreutils-sha3-256sum
    #Set-Alias -Name sha3-384sum -Value coreutils-sha3-384sum
    #Set-Alias -Name sha3-512sum -Value coreutils-sha3-512sum
    #Set-Alias -Name sha384sum   -Value coreutils-sha384sum
    #Set-Alias -Name sha3sum     -Value coreutils-sha3sum
    #Set-Alias -Name sha512sum   -Value coreutils-sha512sum
    #Set-Alias -Name shake128sum -Value coreutils-shake128sum
    #Set-Alias -Name shake256sum -Value coreutils-shake256sum
    #Set-Alias -Name shred       -Value coreutils-shred
    #Set-Alias -Name shuf        -Value coreutils-shuf
    #Set-Alias -Name sleep       -Value coreutils-sleep # Reserved keyword/alias
    #Set-Alias -Name sort        -Value coreutils-sort # Reserved keyword/alias
    Set-Alias -Name split       -Value coreutils-split
    #Set-Alias -Name sum         -Value coreutils-sum
    #Set-Alias -Name sync        -Value coreutils-sync
    #Set-Alias -Name tac         -Value coreutils-tac
    Set-Alias -Name tail        -Value coreutils-tail
    #Set-Alias -Name tee         -Value coreutils-tee # Reserved keyword/alias
    #Set-Alias -Name test        -Value coreutils-test
    Set-Alias -Name touch       -Value coreutils-touch
    #Set-Alias -Name tr          -Value coreutils-tr
    Set-Alias -Name true        -Value coreutils-true
    #Set-Alias -Name truncate    -Value coreutils-truncate
    #Set-Alias -Name tsort       -Value coreutils-tsort
    #Set-Alias -Name uname       -Value coreutils-uname
    #Set-Alias -Name unexpand    -Value coreutils-unexpand
    #Set-Alias -Name uniq        -Value coreutils-uniq
    #Set-Alias -Name unlink      -Value coreutils-unlink
    #Set-Alias -Name vdir        -Value coreutils-vdir
    #Set-Alias -Name wc          -Value coreutils-wc
    Set-Alias -Name whoami      -Value coreutils-whoami
    #Set-Alias -Name yes         -Value coreutils-yes
} catch { }
