package REPS::CMS::BackUp;

use strict;
use CGI::Carp qw(fatalsToBrowser);
use File::Path;

#for output
use Data::Dumper;
use DB_File;

sub new{
	my ($class,$app) = @_;
	my $self = {
		_app => $app
		};

	return bless $self,$class;
}


# added by n-style; 
# 2006.02.24 Backup 1.0
sub backup{
	my $self = shift;
	my $db_path = shift;
	my $type = shift;
	my $label = shift;

$Data::Dumper::Indent = 1;  # don't use newlines to layout the output(Style 1 outputs a readable form with newlines but no fancy indentation)
$Data::Dumper::Useqq  = 1;  # use double quoted strings with "\n" escapes

my %data;
my $dlFileName = 'reps-' . $type . '-backup.dump';
tie (%data, 'MLDBM', $db_path, O_RDONLY, 0666, $DB_BTREE, 'read') or croak $!;
    # Octet-stream�Ȥ��ƽ���
    print "Content-type: application/octet-stream; charset=Shift_JIS\n";
    print "Content-Disposition: attachment; filename=\"$dlFileName\"\n\n";
print STDOUT Dumper(\%data);
untie %data;
#exit (0);
if(exists $ENV{MOD_PERL}){Apache::exit();}else{exit(0);};

#	if ($db_path){
#		my %data;
#
#		if (-f $db_path){
#			tie (%data, 'MLDBM', $db_path, O_RDONLY, 0666, $DB_BTREE, 'read') or croak $!;#
			
#			my $dir='backup';
#			
#			# �ǥ��쥯�ȥ꤬¸�ߤ��ʤ����˺���
#			if (! -d $dir){
#				eval { mkpath($dir) };
#				if ($@) {
#					return "$@<br />";
#				}
#			}
#			my $tainted = $dir.'/reps-' . $type . '-backup.dump';
#			$tainted =~ m|([\w\-\_\/\.]*)|;
#			my $filename = $1;

			# �ե�����κ����Ƚ񤭹���
#			open( OUT, ">$filename" ) or croak $!;
#			print OUT Dumper(\%data);
#			close( OUT );
#			untie %data;
#			chmod oct("0755"), $filename;

#			return "$label �ǡ����ΥХå����åפ���λ���ޤ�����<br />";
#		}else{
#			return "$label �ǡ�����¸�ߤ��ޤ���<br />";
#		}
#	}

}

# added by n-style;
# 2006.03.17 Restore 1.0
sub restore{
	my $self = shift;
	my $db_path = shift;
	my $type = shift;
	my $label = shift;

	#my $strForDebug = "{'test' => 'test2', 'test1' => 'test3'}";
	my $key;
	my $value;
	my $item;
	my $strData;
	my $s;
	my %data;
		
	# dump�ե�����̾����
	my $tainted = './backup/reps-' . $type . '-backup.dump';
	$tainted =~ m|([\w\-\_\/\.]*)|;
	my $filename = $1;
	
	my $hash_ref = require $filename;

my $umask;
if ($self->{_app}->cfg('DBUmask')){
    $umask = oct $self->{_app}->cfg('DBUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
	# dump�ǡ���������
	tie (%data, 'MLDBM', $db_path, O_RDWR|O_CREAT, 0660, $DB_BTREE, 'write') or croak $!;
	
	%data = %{$hash_ref};

	untie %data;
umask($old);

	if (-f $db_path){
		return "$label �ǡ�������������λ���ޤ�����<br />";
	}else{
		return "$label �ǡ����������Ǥ��ޤ���Ǥ�����<br />";
	}

}

1;
