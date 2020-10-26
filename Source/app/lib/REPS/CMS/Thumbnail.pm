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
        'image/gif' => 'gif', # gifファイル
        'image/jpeg' => 'jpg', # JPEGファイル
        'image/pjpeg' => 'jpg', # プログレッシブJPEGファイル
        'image/png' => 'png',
        'image/x-png' => 'png'
    );
    my $result='';
    $self->{_image} = '';
    $self->{_thumbnail} = '';

    if ( (!$fh && $q->cgi_error) or (-z $fh) ) {
        $result .= 'ファイルのアップロードでエラーがありました。指定されたファイルが読み取れないか存在しない可能性があります。: ' . $q->cgi_error;
        return $result;
    }
    my $type = $q->uploadInfo($fh)->{'Content-Type'} if $q->uploadInfo($fh);
    unless ($hash_mime{$type}) {
        $result .= $type .' - ファイルの画像形式が不正です。ウェブ用の画像形式（Jpeg,Gif,PNG）しか登録できません。<br />';
    }
    #croak("File transfer error.") unless (defined($fh));
    # ファイルサイズ取得
    #my $size = (stat($fh))[7];
    #my $maxsize = $self->{_app}->cfg('max_file_upload_size_in_kb');
    #if ($size > $maxsize * 1024) {
        # サイズ制限
    #    $result .= "ファイル画像サイズが大きすぎます。 登録できる最大ファイルサイズは $maxsize KB です。";
    #    return $result;
    #}
    #resize:
    
    # ファイル保存 ---------------------------------
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
                close ($fh) if ($CGI::OS ne 'UNIX'); # Windowsプラットフォーム用
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
                             $result .= "生成した画像ファイルのサイズが０です。サムネイル生成に失敗した模様です。$out<br />";
                        }
                        $self->{_thumbnail} = REPS::Util->de_taint($self->{_app}->param('user_id')) . '_' .$kind. '_thumb' . '.' . $thumb_ext;
                        chmod (0644, "$dir" . $self->{_thumbnail});
                    }else{
                        $self->{_thumbnail} = '';
                        #die "failed $out";
                    }

                    #元画像は弄らない事にした。どうも書き込み失敗の画像が生成される
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