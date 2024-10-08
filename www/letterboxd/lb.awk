# lb.awk - generate HTML from letterboxd CSV data
# Author: Alexander Petros
#
# This script processes the reviews.csv file.
# You can download that file (as of this writing) at: https://letterboxd.com/settings/data/
#
# Expects GNU awk (gawk) --csv mode
#
# $1 - date
# $2 - name
# $3 - year
# $4 - URI
# $5 - rating
# $6 - rewatch ('yes' if true)
# $7 - review
# $8 - tags
# $9 - watched date

BEGIN {
  if (!PROCINFO["CSV"]) {
    print "Error: csv mode not detected" > "/dev/stderr"
    print "This script requires GNU awk (gawk) running in --csv mode" > "/dev/stderr"
    exit 1
  }
}

# Skip the first row, which is the header definitions
NR > 1 {
  section = "<section>\n<h2>" $2 " (" $3 ") </h2>\n<p>\n"
  section = section "<dl>\n"

  # Convert the rating into stars
  rating = ""
  for (i = 1; i <= $5; i++) {
    rating = rating "&starf;"
  }
  # Add a half-star if there is one
  if ($5 - i == -.5) rating = rating "½"
  section = section "<dt>Rating<dd>" rating "\n"

  section = section "<dt>Watched<dd>" $9 "\n"
  if ($8) {
    section = section "<dt>Tags<dd>" $8 "\n"
  }
  section = section "</dl>"

  # Add <p> tags to all the blank lines in the review
  review = $7
  gsub(/\n\n/, "<p>", review)
  section = section "<p>\n" review "\n</section>\n"

  # Load each review (section) into an array.
  # It would be nice to do this with O(1) space usage,
  # but reversing the order properly is actually a bit tricky
  sections[NR] = section
}

END {
  # Print out all the webpage header stuff
  print "<!DOCTYPE html>"
  print "<html lang=en>"
  print "<meta charset=UTF-8>"
  print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
  print "<title>Letterboxd Reviews</title>"
  print "<style>"
  print "html { line-height: 1.4; font-size: 18px; }"
  print "body { max-width: 800px; margin: 0 auto; padding: 0 10px; }"
  print "dl { display: grid; grid-template-columns: max-content 1fr }"
  print "dt { font-weight: bold; &::after { content: \":\" }}"
  print "</style>"

  print "<h1>Letterboxd Reviews</h1>"
  print "<p>Generated from <a href=https://letterboxd.com/apetros>my letterboxd</a> with <a href=https://alexanderpetros.com/letterboxd/lb.awk>lb.awk</a>."
  print "<p>Last Updated: " strftime("%b %d, %Y")

  # Print the reviews in reverse-chronological order
  for (i = NR; i > 1; i--) {
    print sections[i]
  }
}
