set linesize 5000
set pagesize 0
set trimspool on
set feedback off
set verify off
set trimout on 
set heading off
select	   'request_id=' || RE_ID || 
           '|request_type=' || decode (RE_TYPE,'C', 'Copy',
                        'I', 'Insert_Tape', 
                        'D', 'Delete', 
                        'A', 'Archive', 
                        'O', 'Partial_Restore', 
                        'L', 'Delete_Instance',
                        'R', 'Restore',
                        RE_TYPE) ||
           '|submissiondate=' ||to_char(RE_SUBMISSION_DATE,'dd-MM-yyyy HH24:MI:SS') ||
           '|completiondate=' || to_char(RE_COMPLETION_DATE,'dd-MM-yyyy HH24:MI:SS') || 
           '|duration=' || round((re_completion_date-re_submission_date)*24*60*60) ||
           '|status=' || decode(RE_STATUS,'A','Aborted',
                         'C','Completed',
                         'X','Cancelled',RE_STATUS) ||
           '|objectname=' || r.re_object_name_parameter|| 
           '|category=' || r.re_category_parameter||
           '|group=' || r.re_group_parameter||
           '|instance=' || r.re_instance_id||
           '|filespath=' || r.re_files_path_parameter||
           '|fileslist=' || (select listagg(rf_file_name,',' ) within group (order by rf_file_sequence) fileslist
                           from DP_REQUEST_FILES
                           where rf_request_re_id=re_id) ||
           '|priority=' || r.re_priority_parameter|| 
           '|qos=' || r.re_qos_parameter||
           '|priority=' || r.re_priority_parameter||
           '|comments=' || r.re_comments_parameter||
           '|options=' || r.re_options_parameter||
           '|tape=' || r.re_tape_parameter||
           '|tape_destination=' || r.re_tape_destination||
           '|errors_associated=' || r.re_errors_associated||
           '|addservices=' || r.re_add_services_parameter||
           '|prformat=' || to_char(r.re_partial_restr_fmt_parm) ||
           '|additional_info=' ||  replace(r.re_additional_info,chr(10)) ||
           '|thirdparty_id=' || r.re_thirdparty_id ||
           '|archived_date=' || to_char(ao_date_archive,'dd-MM-yyyy HH24:MI:SS') ||
           '|content_age=' || to_char(to_number(RE_SUBMISSION_DATE-ao_date_archive),'FM999999.99') request
      from DP_REQUESTS r, DP_ARCHIVED_OBJECTS ao  
      where to_char(RE_COMPLETION_DATE,'yyyy-MM-dd') = '&1' and
      		ao.ao_object_name(+)=r.re_object_name_parameter and ao.ao_category(+)=re_category_parameter
	  order by RE_COMPLETION_DATE;
exit;