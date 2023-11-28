CREATE MATERIALIZED VIEW tracks.mv_tracks AS (
    WITH points AS (
	    SELECT
	        t.*,
	        t2.track,
	        t3.t_ili_tid as track_t_ili_tid
	    FROM
	        tracks.trackpoint t 
	    LEFT JOIN
	        tracks.tracksegment t2 ON t.tracksegment = t2.t_id 
	    LEFT JOIN
	        tracks.track t3 ON t2.track = t3.t_id 
	    ORDER BY t.atime ASC
    ), 
    linestrings AS (
	    SELECT
	        ST_MakeLine(apoint) as wkb_geometry,
	        t_datasetname,
	        MIN(atime) as starttime,
	        max(atime) as endtime,
	        tracksegment,
	        track,
	        track_t_ili_tid 
	    FROM
	        points
	    GROUP BY
	        t_datasetname,
	        tracksegment,
	        track,
	        track_t_ili_tid 
    ),
    multilinestrings AS (
        SELECT
            t_datasetname AS cmt,
            ST_Collect(wkb_geometry) AS wkb_geometry,
            MIN(starttime) AS starttime,
            MAX(endtime) AS endtime,
            track,
            track_t_ili_tid
        FROM
            linestrings
        GROUP BY
            t_datasetname,
            track,
            track_t_ili_tid 
    )
	SELECT
	    track_t_ili_tid,
	    cmt,
	    wkb_geometry,
	    date(starttime) as "date",
	    st_lengthspheroid(wkb_geometry, 'SPHEROID("GRS_1980",6378137,298.257222101)'::spheroid) / 1000::double precision AS length,
	    starttime,
	    endtime,
	    to_char(endtime - starttime, 'HH24:MI:SS'::text) AS duration
	    --track
	FROM
	    multilinestrings
)

