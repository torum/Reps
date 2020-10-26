package REPS::CMS::Thumbnail;

use strict;
use base qw( Class::ErrorHandler );
use File::Path;

sub new{
    my ($class,$app) = @_;
    my $self = {
        _app => $app,
        _image => '',
        _thumbnail => '',
        _resizer => &init()
        };
    return bless $self,$class;
}
 
sub init{
    if ( eval 'use Image::Magick; 1;' ) {return Image::Magick->new;}else{return 0;}
}

sub save_Thumbnail {
    my ($self,$fh, $dir,$kind) = @_;
    my $q = $self->{_app}->query();
    my %hash_mime = (
        'image/gif' => 'gif', # gif�ե�����
        'image/jpeg' => 'jpg', # JPEG�ե�����
        'image/pjpeg' => 'jpg', # �ץ���å���JPEG�ե�����
        'image/png' => 'png',
        'image/x-png' => 'png'
    );
    my $result='';
    $self->{_image} = '';
    $self->{_thumbnail} = '';

    if ( (!$fh && $q->cgi_error) or (-z $fh) ) {
        $result .= '�ե�����Υ��åץ��ɤǥ��顼������ޤ��������ꤵ�줿�ե����뤬�ɤ߼��ʤ���¸�ߤ��ʤ���ǽ��������ޤ���: ' . $q->cgi_error;
        return $result;
    }
    my $type = $q->uploadInfo($fh)->{'Content-Type'} if $q->uploadInfo($fh);
    unless ($hash_mime{$type}) {
        $result .= $type .' - �ե�����β��������������Ǥ����������Ѥβ���������Jpeg,Gif,PNG�ˤ�����Ͽ�Ǥ��ޤ���<br />';
    }
    #croak("File transfer error.") unless (defined($fh));
    # �ե����륵��������
    #my $size = (stat($fh))[7];
    #my $maxsize = $self->{_app}->cfg('max_file_upload_size_in_kb');
    #if ($size > $maxsize * 1024) {
        # ����������
    #    $result .= "�ե�����������������礭�����ޤ��� ��Ͽ�Ǥ������ե����륵������ $maxsize KB �Ǥ���";
    #    return $result;
    #}
    #resize:
    
    # �ե�������¸ ---------------------------------
    if ($dir){
        if (! -d $dir){
            #eval { File::Path::mkpath($dir) };
            #for SuExec
            $self->{_app}->mkpath($dir);
            if ($@) {
            $result .= "$@<br />";
            }
        }
    }
    if (!$result){
        require REPS::Util;
        my $filename = "$dir" . REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' . $kind . '.' . "$hash_mime{$type}";
        if (-w $dir){
            eval {
my $umask;
if ($self->{_app}->cfg('UploadUmask')){
    $umask = oct $self->{_app}->cfg('UploadUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);

                my ($buffer);
                open (OUT, ">$filename") || die ("Can not write a file.");
                binmode (OUT);
                while(read($fh, $buffer, 1024)){
                    print OUT $buffer;
                }
                close (OUT);
                close ($fh) if ($CGI::OS ne 'UNIX'); # Windows�ץ�åȥե�������
                chmod (0644, "$filename");

                if ($self->{_resizer}){
                    my $image = $self->{_resizer};
                    $image->Read($filename);
                    $image->Scale(geometry => '210x230');
                    $image->Write("$dir" . REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' .$kind. '_thumb' . '.' . "$hash_mime{$type}");
                    $self->{_thumbnail} = REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' .$kind. '_thumb' . '.' . "$hash_mime{$type}";
                    chmod (0644, "$dir" . $self->{_thumbnail});

                    @$image = ();

                    $image->Read($filename);
                    $image->Scale(geometry => '500x400');
                    $image->Write($filename);
                    ##chmod (0644, "$filename");

                    @$image = ();
    
                    $self->{_image} = REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' .$kind.  '.' . "$hash_mime{$type}";


                }elsif ($self->{_app}->cfg('NetPBMPath')){

                    my $in = $filename;

                    
                    my $jpegtopnm  = $self->{_app}->cfg('NetPBMPath').'/jpegtopnm';
                    my $pnmscale   = $self->{_app}->cfg('NetPBMPath').'/pnmscale';
                    my $pngtopnm   = $self->{_app}->cfg('NetPBMPath').'/pngtopnm';
                    my $giftopnm   = $self->{_app}->cfg('NetPBMPath').'/giftopnm';
                    my $pnmtojpeg  = $self->{_app}->cfg('NetPBMPath').'/pnmtojpeg';
                    my $pnmtopng   = $self->{_app}->cfg('NetPBMPath').'/pnmtopng';

                    my $w=230;
                    my $h=210;
                    my $q=75;
#if (! -x $jpegtopnm){
#    die "no $jpegtopnm";
#}
my $thumb_ext='';
if( $hash_mime{$type} eq 'jpg' ){
$thumb_ext = 'jpg';
}elsif( $hash_mime{$type} eq 'png' ){
$thumb_ext = 'jpg';
}elsif( $hash_mime{$type} eq 'gif' ){
$thumb_ext = 'jpg';
}
                    my $out = "$dir" . REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' .$kind. '_thumb' . '.' . $thumb_ext;
                    
                    eval{
                        if( $hash_mime{$type} eq 'jpg' ){
                            #system( "$jpegtopnm $in | $pnmscale -xsize $w -ysize $h | $pnmtojpeg --quality=$q > $out" );
                            system( "$jpegtopnm $in | $pnmscale -width $w | $pnmtojpeg --quality=$q > $out" );
                        }elsif( $hash_mime{$type} eq 'png' ){
                            #system( "$pngtopnm $in | $pnmscale -xsize $w -ysize $h | $pnmtojpeg --quality=$q > $out" );
                            system( "$pngtopnm $in | $pnmscale -width $w | $pnmtojpeg --quality=$q > $out" );
                        }elsif( $hash_mime{$type} eq 'gif' ){
                            #system( "$giftopnm $in | $pnmscale -xsize $w -ysize $h | $pnmtojpeg --quality=$q > $out" );
                            system( "$giftopnm $in | $pnmscale -width $w | $pnmtojpeg --quality=$q > $out" );
                        }else{die "image type ($hash_mime{$type}) not supported.";}

                    };
                    if ($@) {
                    $result .= "$@<br />";
                    }

                    if (-e $out){
                        if (-z $out) {
                             $result .= "�������������ե�����Υ����������Ǥ�������ͥ��������˼��Ԥ������ͤǤ���$out<br />";
                        }
                        $self->{_thumbnail} = REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' .$kind. '_thumb' . '.' . $thumb_ext;
                        chmod (0644, "$dir" . $self->{_thumbnail});
                    }else{
                        $self->{_thumbnail} = '';
                        #die "failed $out";
                    }

                    #��������Ϯ��ʤ����ˤ������ɤ���񤭹��߼��Ԥβ��������������
                    $self->{_image} = $self->{_image} = REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' .$kind.  '.' . "$hash_mime{$type}";
                }else{
                    $self->{_image} = REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' .$kind.  '.' . "$hash_mime{$type}";
                    $self->{_thumbnail} = '';
                }
umask($old);
            };
            if ($@) {
            $result .= "$@<br />";
            }
        }else{
            $result .= 'The resource directory is not writtable.';
        }
    }
    return $result;
}


1