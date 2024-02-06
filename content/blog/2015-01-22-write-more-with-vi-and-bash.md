---
title: Write More with VI and Bash
tags: [linux, blogging]
date: "22 Jan 2015"
draft: false
slug: "write-more-with-vi-and-bash"
summary: A blog post describing a method to streamline the process of creating new blog posts by using a template, an awk script, and a shell script.
---

Part of my New Year's resolution is to write more. My challenge is I'm incredibly busy and incredibly lazy.

To make sure I have no excuses I've already [optimized how I publish](http://brooksgarrett.com/blog/jekyll-github-travisci-s3/). The problem now is I have to keep entering YAML front matter into my posts. Recognizing this causes me to ignore writing I set out to fix it.

My solution is three parts:

  1. A basic template
  1. An awk script to parse the template
  1. A shell script to tie it all together

The template is very basic and essentially contains only the front matter and placeholder markers. I can add or remove from this as needed.

```yaml
---
layout: post
title: @TITLE
categories: [Blog]
tags: [@TAGS]
status: @STATUS
type: article
published: @PUBLISHED
meta:
  _edit_last: '1'

---
```

Next I have an awk script that takes in variables and overwritest the portions of the template marked with placeholders.

```awk
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
```

Last I use this script to tie it all together. The script runs interactively asking for some key information (right now just title and tags.)

```bash
date=`date +%Y-%m-%d`

echo -n "Long title:"
read title
echo -n "Tags:"
read tags



vi `awk -f _template.awk -v title="$title" -v tags="$tags" -v date="$date" _template.md`
```

That's it! I type ./newPost, type in the title and tags I want, and vim opens up ready to go! Now if I can just get images nice and easy...

As always, all the scripts are available in the [GitHub repository](https://github.com/brooksgarrett/website) for this site.