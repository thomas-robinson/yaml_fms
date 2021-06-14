!***********************************************************************
!*                   GNU Lesser General Public License
!*
!* This file is part of the GFDL Flexible Modeling System (FMS).
!*
!* FMS is free software: you can redistribute it and/or modify it under
!* the terms of the GNU Lesser General Public License as published by
!* the Free Software Foundation, either version 3 of the License, or (at
!* your option) any later version.
!*
!* FMS is distributed in the hope that it will be useful, but WITHOUT
!* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
!* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
!* for more details.
!*
!* You should have received a copy of the GNU Lesser General Public
!* License along with FMS.  If not, see <http://www.gnu.org/licenses/>.
!***********************************************************************

!> @file
!! @brief fms_yaml_parser_mod is used as a Fortran layer to the libfyaml library
!! and will handle parsing and returning values from a YAML file 
!! @author Tom Robinson
!! @email gfdl.climate.model.info@noaa.gov
module fms_yaml_parser_mod
use c_to_fortran_mod,  only:fms_c2f_string
use iso_c_binding
implicit none


public :: fms_yaml_read, fms_yaml_key_value


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

function fms_yaml_parse_string (yaml, len_yaml, variable) &
                                    result (c_string)     &
                                    bind (C, name="fms_yaml_parse_string")
 use iso_c_binding
 character (kind=c_char) :: yaml
 integer (C_int), value :: len_yaml
 character (kind=c_char), intent(in) :: variable
 character (kind=c_char) :: c_string
end function fms_yaml_parse_string

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

!> \brief Subrotuine to read the input yaml file and return a c pointer to it
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
 character (kind=c_char) :: c_string
! character (len=*), pointer :: f_string
 var => variableValue
 select type (var)
        type is (integer)
                var = fms_yaml_parse_int (input_yaml,len_trim(input_yaml),variableINyaml)
        type is (real(kind=4))
                var = fms_yaml_parse_real (input_yaml,len_trim(input_yaml),variableINyaml)
        type is (character(*))
                c_string = fms_yaml_parse_string (input_yaml,len_trim(input_yaml),variableINyaml)
                call string_parse (c_string, var)
        class default
                write (6,*) "The type you seek is not yet supported"
 end select
end subroutine fms_yaml_key_value

!> \brief A routine to convert a C string to a fortran string
subroutine string_parse (c_string_in, fortran_string_out)
 character (kind=c_char), intent(in) :: c_string_in !< Input C string
 character(*), intent(out) :: fortran_string_out !< Output fortran string
 character(len=:), allocatable :: fstring !< Temporaty fortran string pointer
 integer :: len_of_string !< Length of the fortran string
 !> Convert the c_string to fortran using the fms_c2f_string routine
 fstring = fms_c2f_string (c_string_in)
 !> Get the length of the string
 len_of_string = len_trim(fstring)
 !> Make sure that the output string is big enough
 if (len(fortran_string_out) .lt. len_of_string) write (6,*) &
     & "The length of the string for this variable need to be increased."
 !> Put the string into the output
    fortran_string_out(1:len_of_string) = fstring(1:len_of_string)
 !> Deallocate the temporary memory
 write (6,*) c_string_in
 write (6,*) fstring
 write (6,*) fstring (1:len_of_string)
 if (allocated(fstring)) deallocate(fstring)
   
end subroutine string_parse


end module fms_yaml_parser_mod


