set linesize 5000
set pagesize 0
set trimspool on
set feedback off
set verify off
set trimout on 
set heading off
select               'event_id=' || e.EE_id ||
                     '|request_id=' || e.ee_request_id ||
                     '|event_name=' || ed.ED_EVENT_NAME||
                     '|duration=' || e.EE_DURATION ||
                     '|tape_type=' || e.ee_tape_type || 
                     '|barcode=' || e.ee_barcode || 
                     '|actor_name=' || e.ee_actor_name || 
                     '|drive_name=' || e.ee_drive_name ||
                     '|drive_serial_name=' || e.ee_drive_serial_number ||
                     '|drive_type=' || e.ee_drive_type ||
                     '|instance_number=' || e.ee_instance_number ||
                     '|media_name=' || e.ee_media_name || 
                     '|completiondate=' || to_char(ee_end_time,'dd-MM-yyyy HH24:MI:SS') ||
                     '|transfer_size=' || e.ee_transfer_size ||
                     '|transfer_rate=' || e.ee_transfer_rate ||
                     '|error_rate=' || e.ee_error_rate ||
                     '|err_code=' || e.ee_error_code ||
                     '|err_msg=' || e.ee_error_message ||
                     '|lib_serial_number=' || e.ee_library_serial_number ||
                     '|disk_name=' || e.ee_disk_name ||
                     '|sd_name=' || e.ee_source_dest_name ||
                     '|ta_name=' || e.ee_transcoder_analyzer_name ||
                     '|diva_system=' || e.ee_diva_system ||
                     '|no_of_operations=' || e.ee_number_of_operations ||
                     '|size=' || e.ee_size event
              from DPRT_EVENT_DEFINITIONS ed, DPRT_EVENTS e 
              where ed.ED_ID=e.ee_event_definition_ed_id and to_char(ee_end_time,'yyyy-MM-dd') = '&1'
			  order by ee_end_time;
exit;