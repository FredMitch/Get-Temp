**free
//-----------------------------------------------------------------------------
// Retrieve current temerature in Alston from wunderground.com
//-----------------------------------------------------------------------------

// Input parameters
dcl-s w_stationid char(50);
dcl-s w_format char(50);
dcl-s w_units char(50);
dcl-s w_apikey char(50);

// Values for HTTP get
dcl-s w_url varchar(2048);
dcl-s w_query varchar(1024);

// Output values
dcl-s w_city char(50);
dcl-s w_time char(50);
dcl-s w_temp packed(5:2);

// Other declarations
dcl-s w_result char(50);

// Setup URL
w_url = 'https://api.weather.com/v2/pws/observations/current';

// Setup input parameters
w_stationid = 'IALSTO9';
w_format = 'json';
w_units = 'm';
w_apikey = '********************************';

// Retrieve current temperature
exec sql
  select neighborhood, obstime, temperature
  into :w_city, :w_time, :w_temp
  from JSON_TABLE(SYSTOOLS.HTTPGETCLOB(
        trim(:w_url) concat
        '?stationId=' concat SYSTOOLS.URLENCODE(trim(:w_stationid), '') concat
        '&format=' concat SYSTOOLS.URLENCODE(trim(:w_format), '') concat
        '&units=' concat SYSTOOLS.URLENCODE(trim(:w_units), '') concat
        '&apiKey=' concat SYSTOOLS.URLENCODE(trim(:w_apikey), '') concat
        '&numericPrecision=decimal'
        , null), '$'
       COLUMNS(
        neighborhood  CHAR(50)  path '$.observations[0].neighborhood',
        obstime       CHAR(50)  path '$.observations[0].obsTimeLocal',
        temperature   FLOAT     path '$.observations[0].metric[0].temp[0]'
        ) error on error
        ) as x;

Select;
  when sqlcode = 0;
    w_result = 'Completed normally';
  when sqlcode = 100;
    w_result = 'No data found';
  when sqlcode > 0;
    w_result = 'Completed with warning';
  when sqlcode < 0;
    w_result = 'Did not complete normally';
endsl;

// Display values returned
DSPLY sqlcode;
DSPLY w_city;
DSPLY w_time;
DSPLY w_temp;

// End of program
return;
                                        