module fms_yaml_parser_mod
!> \author Tom Robinson
!> \email gfdl.climate@noaa.gov
use iso_c_binding
implicit none


public :: fms_yaml_read


interface get_yaml_value
!
integer(c_int) function fms_yaml_parse_int (fyd, variable) &
                                    bind (C, name="fms_yaml_parse_int")
 use iso_c_binding
 type (c_ptr) :: fyd
 character (kind=c_char), intent(in) :: variable
end function fms_yaml_parse_int

end interface 

interface

function fy_document_build_from_string (parser, yaml, string_size) &
                                       result(fyd) bind(C, name="fy_document_build_from_string")
 use iso_c_binding
 type (c_ptr) :: fyd
 type (c_ptr), intent(in) :: parser
 character (kind=c_char), intent(in) :: yaml
 integer (kind=c_int), value, intent(in) :: string_size
end function fy_document_build_from_string
end interface

contains

!> \brief Subrotuine to read the 
function fms_yaml_read (input_yaml, user_defined_parser) result(yaml_c_pointer)
 character (len=*), intent(in) :: input_yaml !< String holding the YAML to be parsed
 type (c_ptr), intent(in), optional :: user_defined_parser !< A parser that has been defined by the user
 type (c_ptr) :: yaml_c_pointer !< The C pointer that can be parsed by the parser
 type (c_ptr) :: user_parser => c_null_ptr !< THe parser to be used for parsing (NULL if none is set up)

 if (present(user_defined_parser)) user_parser = user_defined_parser

 yaml_c_pointer = fy_document_build_from_string(user_parser, input_yaml, len_trim(input_yaml))
 write(6,*) len_trim(input_yaml),new_line("a"), input_yaml
 write (6,'(i0)') fms_yaml_parse_int(yaml_c_pointer, "diag_files/freq") 
end function fms_yaml_read

end module fms_yaml_parser_mod
