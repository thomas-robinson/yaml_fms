module fms_yaml_parser_mod
!> \author Tom Robinson
!> \email gfdl.climate@noaa.gov
use iso_c_binding
implicit none


public :: fms_yaml_read


interface 
!
integer(c_int) function fms_yaml_parse_int (yaml, len_yaml, variable) &
                                    bind (C, name="fms_yaml_parse_int")
 use iso_c_binding
 character (kind=c_char) :: yaml
 integer (C_int), value :: len_yaml
 character (kind=c_char), intent(in) :: variable
end function fms_yaml_parse_int

real(c_float) function fms_yaml_parse_real (yaml, len_yaml, variable) &
                                    bind (C, name="fms_yaml_parse_float")
 use iso_c_binding
 character (kind=c_char) :: yaml
 integer (C_int), value :: len_yaml
 character (kind=c_char), intent(in) :: variable
end function fms_yaml_parse_real

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
!> Parse the YAML
 if (present(user_defined_parser)) then
        yaml_c_pointer = fy_document_build_from_string(user_defined_parser, input_yaml, len_trim(input_yaml))
 else
        yaml_c_pointer = fy_document_build_from_string(c_null_ptr, input_yaml, len_trim(input_yaml))
 endif
end function fms_yaml_read

!> \brief Gets the value of a variable from the YAML
!!
!! \description
!! The YAML stores infromation in a hierarchical manner which can be directly
!! accessed through this routine.  Here is an example of how to use this routine
!! with the following YAML
!! \verbose
!! first: 1
!! hello: "world"
!! top:
!!      sub: true
!!      tree:
!!              subtree: 3
!! \end verbose
!! To get the value of first, you would pass the YAML string, a string looking
!! for first, and an integer to hold the value of first like this
!! ```fortran
!! call fms_yaml_key_value (input_yaml,"/first %d", firstValue)
!! ```
!! To get the value for subtree, it would look like this:
!! ```fortran
!! call fms_yaml_key_value (input_yaml,"/top/tree/subtree %d", firstValue)
!! ```
!! Use %d for integers, %s for string, and %f for reals
subroutine fms_yaml_key_value (input_yaml, variableINyaml, variableValue)
 character (len=*), intent (IN) :: input_yaml     !< String containing the YAML
 character (len=*), intent (IN) :: variableINyaml !< The string formatted with the
                                                  !! hierarchical structure of the key
 class(*), target, intent (IN)  :: variableValue  !< The value of the key
 class(*), pointer              :: var => NULL()  !< Pointer to the variable value
 
 var => variableValue
 select type (var)
        type is (integer)
                var = fms_yaml_parse_int (input_yaml,len_trim(input_yaml),variableINyaml)
        type is (real(kind=4))
                var = fms_yaml_parse_real (input_yaml,len_trim(input_yaml),variableINyaml)
        class default
                write (6,*) "The type you seek is not yet supported"
 end select
end subroutine fms_yaml_key_value 

end module fms_yaml_parser_mod
