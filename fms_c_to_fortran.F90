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
use, intrinsic :: iso_c_binding

  interface
    integer(c_size_t) pure function c_strlen(s) bind(c,name="strlen")
      import c_size_t, c_ptr
      type(c_ptr), intent(in), value :: s
    end function
    subroutine c_free(ptr) bind(c,name="free")
      import c_ptr
      type(c_ptr), value :: ptr
    end subroutine
  end interface


contains
!> \brief Converts a c_char string to a fortran string with type character.
function fms_c2f_string (cstring) result(fstring)
! character(c_char), intent(in) :: cstring(*) !< The C string to convert to fortran
 type (c_ptr) :: cstring
 character(len=:), allocatable :: fstring    !< The fortran string returned
 character(len=:,kind=c_char), pointer :: string_buffer !< A temporary pointer to between C and Fortran 
 integer(c_size_t) :: length !< The string length
 integer :: i
 
  length = c_strlen(cstring)
  allocate (character(len=length, kind=c_char) :: string_buffer)
! call c_f_pointer (cstring, string_buffer, c_strlen(cstring))
    block
      character(len=length,kind=c_char), pointer :: s
      call c_f_pointer(cstring,s)  ! Recovers a view of the C string
      string_buffer = s                   ! Copies the string contents
    end block

! c_loop: do !> Loop through the C string until you find the C_NULL_CHAR
!     if (cstring(length) == c_null_char) then
!          length = length - 1 !> When C_NULL_CHAR is found set the correct length
!          exit c_loop
!     endif
!     length = length + 1
! enddo c_loop
 allocate(character(len=length) :: fstring) !> Set the length of fstring
! do i = 1,length !> Copy the strings in the C string array into the fortran string fstring
!     fstring(i:i) = string_buffer(i)
! enddo
fstring = string_buffer

! call c_free(string_buffer)
 
end function fms_c2f_string


end module c_to_fortran_mod


