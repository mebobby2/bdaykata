# Bdaykata

## IEX
Start:
```
MIX_ENV="test" iex -S mix
```

Load test files in iex:
```
ExUnit.start()
c "test/generators_test.exs"
:proper_check.sample(PbtGenerators.path())
```

Or can also use :proper_gen and :proper_types

## Tests
Run:
```
mix test
```

Sometimes, you need to clean propcheck after making a code fix:
```
MIX_ENV=test mix propcheck.clean
```
