# Github Paper Collaborator

This project is a demonstration of my workflow for collaborating with other
authors on an academic paper via GitHub and a custom webhook.  This workflow
was used to facilitate a successful remote collaboration on the paper
[Capturing Quality: Retaining Provenance for Curated Volunteer Monitoring Data][provenance]

## TL; DR

 1. Create a git repo containing source files and a PDF compiling build script.
 2. Share the repo online with your collaborators, and configure a "webhook" to
    tell GitHub (/Bitbucket, etc.) to POST to your website every time new
    commits are added to the repo (i.e. continuous integration).
 3. Configure your website to pull from the repo and execute the build script
    whenever it receives a POST from GitHub.  Place the output PDF in a
    publicly accessible folder.
 
Once this is set up, everyone can use whatever online editors or command line
applications they like, and the paper will be automatically regenerated after
each commit.

## Rationale

Why use GitHub for paper collaboration?  After all, projects like [ShareLatex]
already make remote collaboration a breeze.  (Or [so I hear]; I haven't had a
chance to try it yet myself.)

There are a number of benefits to the GitHub+webhook approach, many inherited
from git:

 - Full control over the PDF compilation process.  You don't even have to use
   LaTeX (or be writing a paper for that matter).
 - The ability to work on large or experimental changes offline and share them
   afterward.
 - Built-in support for merging and other complex tasks that arise when
   multiple people are working on the same document.

Some disadvantages include:

 - Significant startup effort, especially compared to hosted solutions like
   ShareLatex.  You probably don't want to do this unless at least one of your
   authors is already comfortable with git.  That said, once things are set up,
   you and your collaborators should be able to do almost everything online
   without using command-line git.
 - You'll need a public facing webserver with the ability to execute shell
   scripts.
 - The PDF generation is fast but not live (though you can live-preview the
   Markdown depending on which editor you use).

## Step 1: Create Repository

The core of the workflow is a git repository containing source files and a
build script.  ([This repository] is an example).  Technically there are two
build scripts: one that just compiles the PDF, and a second script that pulls
the source from GitHub and then calls the first script.  This separation is
important if you're ever working on a local copy and want to be able to build
the paper without pulling from GitHub.  It also is likely that the second
script will be identical or nearly identical between projects.  To keep things
simple for everyone (and secure in Step 3) it is best if both scripts can be
called without any command line arguments.

As noted above, you can use any tool you like for the build process (as long as
it has a command line interface).  I typically use [Pandoc], which supports a
variety of markup and output formats.  My personal favorite is [Markdown].
Markdown is easy to read and write, and I use it on a daily basis for
everything else I write (READMEs, documentation, presentations...) so it's
easier for me than remembering LaTeX.
  
Markdown is sufficient for prose in an academic paper, but lacks a lot of
functionality that LaTeX provides.  For citations and complex figures we revert
to using LaTeX snippets within the Markdown, which Pandoc supports just fine.

## Step 2: Configure GitHub

The second step is to create a repository on GitHub and push your local
changes to the repository.  (Of course, you can also create the repository on
GitHub first).  This example repository is public, but you will likely want to
make yours private, at least while you are working on it.  GitHub provides
[up to 5 free private repositories](https://education.github.com/discount_requests/new)
for students; otherwise there's always [Bitbucket].

Share your repository with your collaborators to give them write access.
Finally, set up a [Webhook] pointing to the URL you set up in Step 3.

## Step 3: Configure Web Service

The next step is to set up a website that has the ability to execute the build
script in response to a Webhook POST.  The content of the POST will be
provided by GitHub/Bitbucket after every commit.  I'm a pretty heavy Django
user, so I use my own [Django GitHub Hook] project ([pypi: django-github-hook])
which makes it easy to set up webhook handlers (assuming you already have
Django installed).  A PHP or CGI script would also suffice.

If your department/lab/school doesn't provide web servers (or doesn't allow you
to execute arbitrary code on them), [DigitalOcean] provides Ubuntu servers for
$5/month.

Note that the web server user (usually `www-data` on Ubuntu) will need write
access to a local copy of your repository.  It will also need to be able to
pull from your remote repository.  If you made your repository private in step
2, this is a bit tricky.  You can either:

 1. Give `www-data` its own SSH key and add it to your GitHub account
 2. Give `www-data` the ability to `sudo`-execute a specific script as your Linux account.

Needless to say, both of these are risky so be sure your web server is secure.
Django GitHub Hook does not pass any information from the webserver to the
script it executes (which is why the script needs to run without requiring
command line arguments).

# Step 4: Edit Away!

GitHub's built-in online editor works great for Markdown.  [prose.io] is
another good choice for online editing.  Ocassionally, you may still want to
break down to command-line git for large multi-file commits or other
significant changes (but always do it in your local copy, not the webserver's).
The nice thing is, it's totally up to each author how they want to contribute.
All commits are the same from the perspective of the webhook!

[provenance]: http://wq.io/research/provenance
[ShareLatex]: https://www.sharelatex.com/
[so I hear]: https://twitter.com/jeffbigham/status/500304217240637441
[DigitalOcean]: http://www.digitalocean.com
[This repository]: https://github.com/sheppard/github-paper-collaborator
[Pandoc]: http://johnmacfarlane.net/pandoc/
[Markdown]: http://daringfireball.net/projects/markdown/
[Bitbucket]: https://bitbucket.org
[Webhook]: https://help.github.com/articles/creating-webhooks
[prose.io]: http://prose.io
[Django GitHub Hook]: https://github.com/sheppard/django-github-hook
[pypi: django-github-hook]: https://pypi.python.org/pypi/django-github-hook
