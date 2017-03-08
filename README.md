# CurrencyConverter
A commandline currency converter application implemented in Linux using GNUstep

## Compiling the code in command line: 

  clang main.m CurrencyAPIFactory.m ExchangeCalculator.m FixerAPIClient.m `gnustep-config --objc-flags` -fblocks -fobjc-runtime=gnustep -fobjc-arc `gnustep-config --objc-libs` -lobjc -lgnustep-base -o currency

## Executing the project with input arguments:

  ./currency 5 usd cad
