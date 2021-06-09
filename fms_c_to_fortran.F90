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
!! @brief Utility routines for Fortran/C interoporability
!! @author Tom Robinson
!! @email gfdl.climate.model.info@noaa.gov
module c_to_fortran_mod 
use iso_c_binding

contains
!> \brief Converts a c_char string to a fortran string with type character.
pure function fms_c2f_string (cstring) result(fstring)
 character(c_char), intent(in) :: cstring(*) !< The C string to convert to fortran
 character(len=:), allocatable :: fstring    !< The fortran string returned
 integer :: length !< The string length
 integer :: i
 length = 1
! call c_f_pointer (cstring,
 c_loop: do !> Loop through the C string until you find the C_NULL_CHAR
     if (cstring(length) == c_null_char) then
          length = length - 1 !> When C_NULL_CHAR is found set the correct length
          exit c_loop
     endif
     length = length + 1
 enddo c_loop
 allocate(character(len=length) :: fstring) !> Set the length of fstring
 do i = 1,length !> Copy the strings in the C string array into the fortran string fstring
     fstring(i:i) = cstring(i)
 enddo
 
end function fms_c2f_string


end module c_to_fortran_mod


