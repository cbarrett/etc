function numstat-sum
    awk '
    NF!=3 { next }
    !($3 in F) { 
        fcnt++  # track size of F ourselves
        F[$3] = ""  # just using F to collect and dedupe filenames
        if (maxname < length($3)) { maxname = length($3) }
    }
    {
        A[$3] += $1; asum += $1
        D[$3] += $2; dsum += $2
    }
    maxsum < A[$3] + D[$3] { maxsum = A[$3] + D[$3] }
    END {
        sp = sprintf("%*s", maxsum, "") 
        pluses = sp; gsub(/ /, "+", pluses)  # no really, this is how you repeat a character in awk
        minuses = sp; gsub(/ /, "-", minuses)
        maxsumdigits = int(log(maxsum) / log(10) + 1)  # for any n, the number of decimal digits in n = log base 10 of n rounded up
        scale = ('$COLUMNS' - maxname - 3 - maxsumdigits - 1) / maxsum  # numer is number of columns available, denom is our longest bar to show
        sort = "sort -t \\| -k 1"  # this is how you pipe to an external process in awk, apparently
        for (n in F) {
            ps = int(A[n] * scale)
            ms = int(D[n] * scale) 
            # * means pad on the left, -* likewise on the right, and .* truncate,
            # with the desired width given by an extra (preceding) argument
            printf("%-*s | %*d ", maxname, n, maxsumdigits, A[n] + D[n]) | sort
            printf("%s%.*s%s", "'(tput setaf 2)'", ps, pluses, "'(tput sgr0)'") | sort  # use tput to get color escape codes
            printf("%s%.*s%s\n", "'(tput setaf 1)'", ms, minuses, "'(tput sgr0)'") | sort
        }
        close(sort)
        printf("%d files changed, %d insertions(+), %d deletions(-)\n", fcnt, asum, dsum) 
    }'
end
