job_scour
=========

Because what unemployed hacker hasn't made a scraper bot for job listings?  Seriously.  It's the worst.

Right now, this quick and diry Ruby script pulls in keyword-filtered data from the Made in NYC listings from New York Tech Meetup group, and outputs the urls for job listings featuring any of the given keywords.  Right now this only supports job listings that exist on the company's page, and doesn't follow through to external job listing boards.

Future enhancements might include:

- following links to external job listing sites
- handling for other listing sites like Craigslist, Careers 2.0, etc
- Gemification