select neighborhood, obstime, temperature
  from JSON_TABLE(SYSTOOLS.HTTPGETCLOB(
        'https://api.weather.com/v2/pws/observations/current' concat
        '?stationId=' concat SYSTOOLS.URLENCODE('IALSTO9', '') concat
        '&format=' concat SYSTOOLS.URLENCODE('json', '') concat
        '&units=' concat SYSTOOLS.URLENCODE('m', '') concat
        '&apiKey=' concat SYSTOOLS.URLENCODE('********************************', '') concat
        '&numericPrecision=decimal'
        , null), '$'
       COLUMNS(
        neighborhood  CHAR(50)  path '$.observations[0].neighborhood',
        obstime       CHAR(50)  path '$.observations[0].obsTimeLocal',
        temperature   FLOAT     path '$.observations[0].metric[0].temp[0]'
        ) error on error
        ) as x          