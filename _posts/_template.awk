BEGIN {
    if (length(title)==0) {
        print "No title specified." > "/dev/stderr";
        exit 1;
    }
    if (length(tags)==0){
        tags = "Blog";
    }
    if (length(status)==0){
        status = "published";
    }
    if (length(published)==0){
        published = "true";
    }
    slug = tolower(title);
    gsub(/[^a-z0-9]/, "-", slug);
    gsub(/--+/, "-", slug);
    gsub(/-$/, "", slug);
    if (length(slug)>35){
        count = split(slug, parts, "-");
        len = 0;
        slug = "";
        
        for (i = 1; i < count; i++){
            if (len == 0){
                slug = date "-" parts[i];
                len = length(parts[i]);
                }
            else {
                len = len + length(parts[i]);
                if (len < 35){
                    slug = (slug "-" parts[i]);
                    } 
                else {
                    slug = (slug ".md");
                    break;
                    }
                }
            }
        }
        else {
            slug = (date "-" slug ".md")
            } 
}

/@TITLE/ {
    gsub(/@TITLE/, title);
    print > slug;
    next;
    }
/@TAGS/ {
    gsub(/@TAGS/, tags);
    print > slug;
    next;
    }
/@STATUS/ {
    gsub(/@STATUS/, status);
    print > slug;
    next;
    }
/@PUBLISHED/ {
    gsub(/@PUBLISHED/, published);
    print > slug;
    next;
    }
/.*/{
    print > slug;
    }

END{
    print slug;
    }
