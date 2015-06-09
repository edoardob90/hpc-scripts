PROGRAM main

! Rotate values clockwise on a ring with MPI
! ------------------------------------------

IMPLICIT NONE
INCLUDE 'mpif.h'


! Each task owns its private set of the following variables
! ---------------------------------------------------------

INTEGER       :: my_rank, tasks_number
CHARACTER*32  :: machine_name
INTEGER       :: ierr, name_length
INTEGER	      :: my_var, left_neighbour, right_neighbour
INTEGER       :: status (MPI_STATUS_SIZE)


! We should start with...
! -----------------------

CALL MPI_INIT (ierr)


! Getting information about the MPI environnement
! -----------------------------------------------

CALL MPI_COMM_RANK (MPI_COMM_WORLD, my_rank, ierr)
CALL MPI_COMM_SIZE (MPI_COMM_WORLD, tasks_number, ierr)
CALL MPI_GET_PROCESSOR_NAME (machine_name, name_length, ierr)


! Initialization
! --------------

my_var = my_rank * 10

right_neighbour = MODULO (my_rank+1, tasks_number)
IF (my_rank-1 .GE. 0) THEN
  left_neighbour = my_rank-1
ELSE
  left_neighbour = tasks_number-1 ! rank of the sender
ENDIF


! Show initial status
! -------------------

write ( *, '(a,i5,a,i5,a,a,a,i5,a)' ) &
  & 'Hello, my rank is ', &
  & my_rank, ' among ', tasks_number, &
  & ' tasks on machine ', machine_name (1:name_length), &
  & " with my_var = ", &
  & my_var, &
  & " initially"


! Let's wait until all the tasks have reached this point
! ------------------------------------------------------

CALL MPI_BARRIER (MPI_COMM_WORLD, ierr)

IF( my_rank .EQ. 0 ) THEN
  WRITE ( *, '(a)' ) &
  & "--- BARRIER! ---"
END IF


! Exchange values with the neighbours
! -----------------------------------

CALL MPI_SENDRECV_REPLACE ( &
  & my_var, 1, MPI_INTEGER, &
  & right_neighbour, 0, left_neighbour, 0, &
  & MPI_COMM_WORLD, status, ierr)

WRITE ( *, '(a, a, i2, a, i2, a, i2, a, i2)' ) &
  & machine_name, &
  & ": rank ", &
  & my_var, &
  & " sends to ", &
  & right_neighbour, &
  & " and receives from = ", &
  & left_neighbour, &
  & ", my_var = ", &
  & my_var


! Let's wait until all the tasks have reached this point
! ------------------------------------------------------

CALL MPI_BARRIER (MPI_COMM_WORLD, ierr)

IF( my_rank .EQ. 0 ) THEN
  WRITE ( *, '(a)' ) &
  & "--- BARRIER! ---"
END IF


! Show final status
! -----------------

write ( *, '(a,i5,a,i5,a,a,a,i5,a)' ) &
  & 'Hello, my rank is ', &
  & my_rank, ' among ', tasks_number, &
  & ' tasks on machine ', machine_name (1:name_length), &
  & " with my_var = ", &
  & my_var, &
  & " finally"


! ...and we should terminate by...
! --------------------------------

CALL MPI_FINALIZE (ierr)
  
END PROGRAM main
