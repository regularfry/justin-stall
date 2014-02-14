justin-stall
============

For when you want to just install the damn gems.

Usage
-----

    justin-stall [--without=development,test] < Gemfile.lock

This reads a `Gemfile.lock` as output by `justin-lock`, and installs
the gems listed in it to the current `$GEM_HOME`, using the same logic
that Bundler would.

That's all it does. Any other behaviour is a bug.

`Gemfile.lock` must be one which `justin-lock` has produced, because
ordinary `Gemfile.lock` files don't contain the original `Gemfile`
contents. That's needed because the groups information isn't written
to the `Gemfile.lock` by the original Bunder code. However,
`Gemfile.lock` files produced by `justin-lock` are backwards
compatible with Bundler; the additional gemfile contents are skipped
by its `LockfileParser`.

Because `justin-stall` reads from stdin, rather than a specific
filename, you can have a lock file per platform, per interpreter patch
level, per day of the week, for all `justin-stall` cares. Manage your
dependencies the way *you* see fit, I'm not making that decision here.


Note
----

As with `justin-lock`, this is a *very* quick and nasty hack, which
involves vendoring most of Bundler and poking at its code in *just*
the right way.

Consider yourself fortunate if `justin-stall` doesn't eat all your
code when you run it.


Author
------

Alex Young <alex@blackkettle.org>

As with `justin-lock`, the overwhelming majority of this code is
yanked wholesale from https://github.com/bundler/bundler.git. Come to
me in case of breakage, go to them in case of praise.
