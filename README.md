# Bdaykata

## IEX
Start:
```
MIX_ENV="test" iex -S mix
```

Load test files in iex:
```
ExUnit.start()
c "test/csv_test.exs"

:proper_gen.pick(CsvTest.csv_source())
:proper_check.sample(PbtGenerators.path())
:proper_types.term()
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
