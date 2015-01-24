# This is processed before any matching.
BEGIN {
    # If the script wasn't given a title, just quit. 
    # Readers looooove titles
    if (length(title)==0) {
        print "No title specified." > "/dev/stderr";
        exit 1;
    }
    # If the script isn't given a tag, default to Blog
    if (length(tags)==0){
        tags = "Blog";
    }
    # If the script isn't given a Publish status, default to published
    if (length(status)==0){
        status = "published";
    }
    # If the script isn't marked to publish, default to publish (true)
    if (length(published)==0){
        published = "true";
    }

    # Generate the filename/slug
    # This is modeled after what Wordpress does
    # First, drop to all lower case
    slug = tolower(title);
    # Replace any non-alphanumerics with a dash
    gsub(/[^a-z0-9]/, "-", slug);
    # Replace multiple dashes with one
    gsub(/--+/, "-", slug);
    # Remove any trailing dash
    gsub(/-$/, "", slug);
    # I think 35 characters is too long. Shorten it
    if (length(slug)>35){
        # Break up the name by sections 
        # We split around '-'
        count = split(slug, parts, "-");
        # len is the current length of the new shorter slug
        len = 0;
        # Init the slug to an empty string
        slug = "";
        # Loop through the parts
        for (i = 1; i < count; i++){
            # The first part, add the date like Jekyll wants
            if (len == 0){
                slug = date "-" parts[i];
                len = length(parts[i]);
                }
            # Not the first part
            else {
                # Add the current parts length and check that we are under 35
                len = len + length(parts[i]);
                # If we are, then add the part
                if (len < 35){
                    slug = (slug "-" parts[i]);
                    } 
                # We are over 35, so add the file extension and bail
                else {
                    slug = (slug ".md");
                    break;
                    }
                }
            }
        }
        # The slug is less than 35, just add the date and extension
        else {
            slug = (date "-" slug ".md")
            } 
}

# Each of these sections find the placeholder and replace it with the 
# proper variable established in the 'BEGIN' section.
# Then we write it out to the 'slug' filename.
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
# This line means what awk sees isn't a placeholder, so just spit it
# out without processing.
/.*/{
    print > slug;
    }

# All done so now print the slug so our shell script can use it as a return value.
END{
    print slug;
    }
