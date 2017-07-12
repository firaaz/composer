ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.9.2
docker tag hyperledger/composer-playground:0.9.2 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �pfY �=�r�8���ڙ^Negʵ�]��fR��ӒH��,��ՔDɊu�us�$�(H�E�l^$�)���W��>������V� %S[�/J��35m8 �s���t�R��i�0dj�m��{ړ�A,���8��b���F���X<�pO6e�O �@��
��� OK���x���Ї���.��)ʆV_U��KQ �<a����_�#�:��t�wǹ$S��m�����`���(?�R�4,��� �w�f�g��A��Z�ރ�3BJ�
���T>K���\v��g �q� �	[��9)Cס�NZFK� ��֒���?K(Ө6��	%�sP�k�i�K5qq�z�@�}6�̖s�_s�����a]�*�a�H����G��W,�D#�ʚ=���ADf&װ��B́��M偙� %\K�Ĵ-SٍD��ax!�Lb�v���3E��R>�Тtd4Q��Q�FI3�=�̥1f�j����,�"ϙ�k�;�c"�9l����g����2�ݽ�!Ǆ+��u������`�:����2��[,[Gt�9�nʽ��� C�$j��:��S�K�ZEJ�N�<� ?�}3Y��/:����+O��Z���4Ѥ�;�q�O���ވ������b�����|<.ܴ�c���8�"<�g�	��9����s�߁��4��@���}� �/�<�,���g�1^�����<����Ͼ�4T=Ґ�e��@@?�&��T-����I��V)��)���/i����4ѯșf�h�G��ֆ_̑,�x:?��s����6��e��7e�����s������o���H;x��T@4��?|t����Fk��e�Ţ}'Fa�LX�R�}P3�*$����:`�σ	ǀ�7���m��P3L��A��� ӵ�&�'��Ծ�`˅$Iv��aM9U<lMU�n����;0�y]8D���n�Nj��U:2�5z�I�bh.�����PG�VE;�Ȯ��������5C��t�>��ۮf�P��&��(�������g�^���FÉ�h;ORC�K��b��؋�e���sS9�2�D�xc������R����ii�u�&�����?���X�A�Z���_�?��Vh�:q��#;��jQ��}�!�\]W���G���|��HQ����M�B��A�ח���5y�"�=@���k\��T:�P{�n5;����� �6����]v^�NR3�RQ��d�r�u���˸���i��R!�p�Wx3�4��F���@�� �*�#桐1;�&���ar��`S ث ��a�iO�}Ƙ���s$2�Vu�#)�7���keALq��kC2 ���ѹ9蓘�L.��Xas�{��(���UR��4�ϡ�A��P���}�Aن��T0�JĲ?��~�{/s��lH��A�s7F�����:Pu<m~�~A�׈�n�9�;��xI��5 ��ׯ��Z#zC�z� !����ӡ-+T���f��Ra�����|?V�� 3�߬�뀍��ˆ9�=����gy.>-����������ų�<�q� KO�6��9fMak7k��Hs-׀��~kH�s�;������UR��au�oH7A�C�ͷ����`��� ��6&�ˡKd�f�d9�:�K�J�T|uqum6�F�Pm��6t~DF���p^¿��K`����CA͆7׉j�[���Y�X�S���R�ճj� �j՛��@�G;+�6D�մ_�ta��+x}�v������	%>�zN���߁w�����<� ����$ĸ���]PD��t�׀~��{M�R��xLttz@'�aEL���*�w�E�i�@(�$�_�"6G�+h����NΏ���j���Ǳ���[l�/���d�y��"���̴�6��k�����]��g����&D�@(dZ��^��:�*���so�#�S����X=�3���M��:`����݃����	��_,?�w^4�qa���Ea��YL}���.���ܲ -˰~����A�ד����<����wv �j+�!_�Hݳ_%�o
��Cہ=���]͉� ��������/ƨ�U�`�0u'�5��@7@Ѡ����XL�Pm�����c�G�kp}^�N�QV���{�(�-�WeG�(~��s�]��A3���=,x��3�����>W�_�#�]?���=��d�8'�;�� ���&.<��F��^���b|�	�afT
7�t��1=j��Y^���Yx����N�?���U�A�.՘G7��U`y�/Kb� �{͕�X��0�_�2�_<{�G쓀}�漕��F�~������������/��F�����������q ��70��GTR�.�-@�\�J���O@*e�ϫ��B�Q�ɝ�%.�8=�C�jV��v&/��E�:���!W�܂7>Dn��w��FG�SW�<��_*HW���Bi��XV����2��E��7�0�ɢL���И��̃k˘�F֑mЀP�'�9減���oE���x���U�?����m,��X>&L��l|����B��
��f�=^>7\�Qwx��6�TD]m{����.�(0�V/\� �R�R���R♈�/�d^J��c� P}���,��Đ���),є��p��(ѐ���T�,�JR�LL��R�"֪��T�RUBn�^@=I�r�Ɜ�HG���\ݗ������K�l��=�Ku)������Lù����Ãܙ����Q<)s���a�+��W�T����LL��R>�z�}WgS]��B�,Kս����U��٨"lMջ�	�`�1�R���Ah�5��t�	�s�x�����พyS�;/�S��*����-���i���6�������؍�Ǐ|$w
��v�J�P-�&�ȩ}@�`��6�st�A�t����06�^b�O�C��������bѻ�o/�+�[���䟽WВ����;�M���������R�E����?���m�����������!?<t|E�좰�W�[�@Gԉ^ƫ��gK���ly�|_~C��� �����+�p{����9q������p���F��_�b���|�_|���qs�`^���P�����W*�_��Z+��t���2w��e��>�B,��Y�/'l���g��_l�[�zj��Ƙm8�<ji�p�K�0ZV��s(x��sx�?�����f�_�W����e�<�\2x�0���ڀ<� �� =|�!����s4F@�X�����J��@/�Y?<3�-��ރ)��8�����_s�_]�~ee:�L���a��@���#*So��}6enŸȜ7R�B)o��z�Њ�O����M����[<t�D߄[��`���������6�
��:`���Vb�z
;��X�-���� D7�������:�>|�����?�����?O�??��F�y.��RX��r��╝D"�j$8��ːg!��D�Wd>!$l#�#p�A����������x+��oԟD��Td� Cd��֟�?���֓o�ST��m�rT����[�Bm����o������j��|5Q�-��v���������ѿ��5��㱥:�����e��8�!�a"��'��װ��z�o���X�+�����2��������[������^�o��Zࣿ�
<��#�j�M�6�iЖAG�a&?�r�T�{��F�PG���@��t*�����6������"��e���x��b��N��i�$`K�;J��0�
����(�-�݉ˉ���#AM���>�
D���� ܝ����AJ*Ws�\J�J$��^��R��TJTRmq�K��\Y,�%�^|5lF�١�6�RW;��'��4wy�Hw�\JyT��͊lMJv
�z�p!]��d�XGUUS�b���z��W>�.2�b��S��:�S�����˸'�vy��\d��[èJ����RrO�v:��I��"�78�b?-�N�*q��{=ߛ�9��(�BU�s\��cJ�w���I3J{��'�#{�::I׏����M�v)Uh�p�R�������Ӿ�̓�t\Hy=�(��5.����ɱp.�-�7.�V!�q08>:.;� ���A�ٌ�d/�|��oT��h$��lr�k�R�b[ʦR�/291�uw.�Gl�{Q��F�/�UO��'�F�p\��I����q=��k��@<��͊�
��i���w��x�.4˱S^fۃ��j5�/�<�Dm3=�������vZ,��/�bkG�E���q����Q��:sɞu*��d.�x�[�|wp����!	�ɥ�Ť2��ʽ������`Jd�bA��rG)�>8���SR��F��;�eB8ND:��x:'��~\��T3�ε+�A����FƐLY�
��[y����eF��D��,����{���TL����*	G~�z;�����d���˰��Pc[�a�{�D����e�mx���p�����;�_t��}������?:��'ʲ����Z `'�su�8�鄤>�
��>Z�����d��؆::j3Ln��'5�P���S�$֙
��ǚ��2i�\��t�� �+%�e����jŲY�u/3r*����R���O)�ޭ���P�hP������Nu���a��9Y#�;̧����d�cRO���7۱O=�|�??��������񩻾�'�����Y����ߵ@p��%�Tp��t��d�w�ģ�+$-)飶(��%e�5��yS�8n���oڦ|؋>��R�4S�JPq˧o�z����h�M�� ߽tt����6o��&�o��jNN�����>M٧���A���c������%�X ��8?}�G��7�_k�g e�C�DO��/�Q�@�٠	_4��3�y�~�{�+�<_nK��.=�fB=����T��6B [����)����d]�$i�d]n�{k��%r��~`�����[9��o����܃�� H=Y�wA ���?t۸F�bB��bB�?;�Q���U��?5��э!�o؎N�睇g�Q������#J���2/���s���}�����lq��!/]�_���Р7�vP$"A�8�����j�"|��O�����w51�y=�Fa�$�ۗ�Uh&��L���o��I�v��������aT�n�{�v{�m��Փ�v�q₄�!q�$$�+BB+��{�U�n{<o�̓Ce�]��U���U��*��юG���0�(>`)�;��pp��f��`D��,P�(�˚h�	ys����lSCU���m��U貫oohI>�+�SN/��bk?���H>'M02��~Q��d�̌�36W�� �\䠜l��<t��/A�<M�Ǜ��?�г2l� ݓ�>wzG[g|�&�+?{��������/g$?�w%�nb	m~��C�΀>��M�!�j��m���T!���ɉb��@�)���ކv��n�~�0`�6t:E_�{0�̯Ӕ`�C�h
Q'�Ԑ��\�/
�,��[Ʒ�	�l��&��/�ϸxx��v���=�n@(�Cc���o��6�#����<����E-�c �j�j[�srE���ӑ���]ۘB�X�%��sS �!���c�����pt ��|$+s�1>"���m���S���Td��ɴk9���<������
��پm�[c��.N�)4*]}jB-���k�BJ��w��&ݹ��Tu�����:l�%e�-:d*(�.*��|~��]C�5����#��8��C��FG���Ʉ��Rhݪ�2����Wu����&��NM�-_�]�k#�Vt��I�Bodk�)xcsO5����k&ѷ����zh�@ү;���?�E��d�����W�!�v����>�V����?����s���������}b�_=|����!E�6E�&E,�_�y���w����~���gRh�g_�c�DF�JJ���D,���R/��e"�x����� ))���xFN�	������>��_O����O����٣�;������;}e�~+B|?��H�? �^!k���}���@���=����{w�������y�����V��1�j0�=�X�-J�~:�ܷ�b��$̳�Ͱ������Y�Z����D +�+_E V��:��Bm;���
�ူ�؎rSb;!���ȼ����Y{.���Y����V��� ̳K����"��B]�9�i<g��vk>�3i���z����Y��)6!��Gž4,����L�윍	��9�ߝ����v���|sڎf,�n�yӰ7/����7X�&5hW���}~yT\0C�t���&�IX�x��G��*��&;�M]��\�Xk����/s��A��3%_o&!a��=!�YT�z�J�
a��}���Ơ�"��@���C?h��1��7m�ϖ���jq�WkjX�y���B��"}·D����F<9��'Ƣ�z��y|���!�:ͫ���,�7�,�8U��y&�'��Z�����x֔�l{yT��Y>�w��$��M�N�Giz6��ben&G�X9����f#�Z���.{�{�6�~I�}I�|I�{I�zI�yI�xI�wI�vI�uI�tIl�\^�̻ě����&��_�(��}��p���g��%�,�;��-.������Y���В��%�|�]\��B�֮�@��v�'m`�=ܼ�
�s?��N��e59E��Tq�3��~�*�,-�i����B��x#�*D�$GͨpR��s"���d<��N���L�dBE��m�^�������y���to?Kg�@d�\y�<�DM=^� �liSݔ�'�X�vn_�~Jta�T(b��2I��j®�L��s�vK�h�D�*��� ��'�=c�raU�|��XK6;�ʤ[%�H��A�����!w����{��"��[�����G���[��7v^�}��rÿ`o7�s���e7��o��x�u6�e�<����u�OC��|#����}v���+����{���
����z#��_�˲�~��'�~�Q��$�B����?r��?x���<��?�֔��Д�`��y+=����T�֢̥�'I�׽����}~�����F7��k���rv�<�\�m�f:O�r������pLW��T�t�֦>��g�+��#�(-���:�Y9�alɬ�4�Q�1K*WHM��dq�W��Y��$����H��re�va_F����M�١�t�q޶�8m�{���0WT5~\<6��M��tű2i��[m�"�;mFms�;���`<��42�����cAf՚�d qˡ��aU����~�x?��@�8�h�`۹��o�|{����5G��4�p�Fk'�bP=�K��o��TDTNR��IFj$!�k�pд�BTA���Yc{T�ό�~\W�;�Q�ş��./��d�����⁽_�Vi�(P��@��.�y�9�	�R�K�*�:�ח����������/mȹ%}������#�k?aE.&��E��[�����0�w�X?�>>�J����wO�	��m�z0����>��o��rY�-�d��Z��5S�^-U���)N���65�r)�?hi��Xi-s6N0��bu���������W�QZ˞2�l���e�3��p�h�	�9'P�
4m9�r�dk6o�jk8�Z��y5W��T�7�O���GpN'tU"�4��c5�/
\u2���>-��Q�$]U�c�XhĦ<抍ԬH0�o�yG�
�z]�
��b<�/�{�lA�����52}jP�P����%�tqY{�B1�_]�e9��ʑ�ٰ6�h��@e���1�BTbK�u$���]G2�y�N�v	F��ؙ�]��	����t& N�<gRG��P����z��(�b��q�(;�7�z���đ�r�	���\֤{�hz֩5x5�-��1t:�h��	�*Q��l��|L_��3�H/��Qn�Pϣlq(�f�-������hi���#��g�B-��D�]vB@\(���w(L�_�i�R��DM�O��|ܢ;"}r��W�ِ��фB�}8�d�f0vcގL�P�&9�j�H��q}!v:�V�Qa�
w�2�ail�>}c��@\�n�`���E�7������c���w`u��s�Q��Л�Qӣ��e���Ӛh΋�ЎO�+�/�_edNMq1VB��"�4��I����e4��zz{�x��/��>��K�o��JZ�6z�x�y�qPD�ƓŇ�M�4��1��1�5�9��2~��>!�/ ���TZWH��ОpM��֧�/b�,������rN'X4;�?���<��9�,O�T�P"�K|��o��^��E^�tn��Tv�ל�����s��Od�o�şk��E���?ģѯ��������+��%p��wӤ��)�j���ϝ\C�y�ܙ�!)���͗�>$F��a���d�
��L�P��Ή��hW�3tT��n�ww�!A��&�i���;��Wצ�����w���'���0�*At�z^���R��4�u=�ŗ�Y^S�_���Y:��pK%�����"���[�V��uÁ����b	� �\ �?���a����(�� �s��~��L]��3A���`����1�7���q���m#�����.�51���$y�4��T�ɑ}jv��4���ԑ�4�<��_P�Wh5��2`	� �t��d�J|L��'X]T�`�2���Kt�lC���§��=P1�w������y����rn<�L��sER@��j���Y���6��49ׅ���w���m��������\�46���C8j���8X!�"tb��Ɣ��$�2(0�N�QW�����s�$��T��ٝȾܺ#�;����M�o"lo.z������}c��lX؏���z���aS�����"��+Nx��0M|ֳ
�hc|l�t��h>��Ŧb�4�Zc�"ZW�����p�Fb���p,��Fʡ̭5n���"rؼ�p�BR�3����pY���Wۀ��5.�oD�7�c����$��G&p��l]`�Һ[�&�������~��)���w���p�I�r��8�
"$���x�/0���Pπ�;�1`N���0�wo z��N�"��S�?�^�{٬۫.^� ݵ��`�P����dTO�`()=�Cm#
H	��|�.�d�\�VIP�5�&�nn������F)�k��W�1�5����bf�`���m@�ce2�MA��@��qs��B�K�%(�)���XfaA!;���/�+!*t½a;x�	D�^�h@�͒WU\U�`e��"`�n��4)0��Uq�6�lTo�?x��#i/|t���cƽRa�n��*T� �5&k�v����7v%�%�\�!=9��L�r�ºf�q�iH�y�8� V@Yݣ�� �rE��䫇�vh�_�M��6�4M��t��L$]Y���<74�h���N��%p���N(-�D�w1�n�-n�0R,ۘ\��)�t��~�ոp���g��'�f������ް�_�����]���2����HES����Qg���翾��q��F?%4���l�sñ����Ûܕ��3��F�����i�>EWc<+V7���;(�dlp�c����i�bKm���ʅ^����
_M[��?E'���k
:��/V�FeЋ%�R )��D��)�D/��u�J��S=
����g��ԓz�$���
�&��9p,�{���{����^���>��K~�Y'�%��T|iȍ[��C|�9<���XR %@��H<I�@��J� @2�(�H:�Vb@�� %��(�B�$P�`ȧ�s�!�;�ɧ�X3�����/<y���M[�v�{�٩�Qn�(���&[�o!�Fe��>x��V�,W��:ϕ�:]:-U�%�+=�i�^N�7D�L�l�k4�Ep|�����'*�3���v����/ٲvE��tIhTy�Y`��:jt�Յ*ͱ�څWV����TF�3acl�U����I7�jV*��t��ֵ�;�b���I�3s�2���}q�z�Z#{��;𖁈p��M	�ҷ/�l�W,�\>�/�z��V��y��?�r\}c����͗�vE�(�1��:�pʕ�j�/�Ϧ#m~��V��L����� �9Q�pH^������q�եͺ����Z�4�l����eNlU�Gl�3O�N��v�]�gM�"Lu�Wi�pQiP�}mYu��aކH���E��ܳ,��e���V����/{W֜��l��+�;u��[�U}� !��҄�'	����`H����N���!&hKk��ݽ��;=���z��I"�[��/�-_v��+��x��m����4��3L}�H��c׹c?z���D���=���{�5=[�������?�jer�W�t��Q���Q��׳��ٶ/�xK\���_?���|swZ�%�܀_��;|�)�����3�ϻ���"�������_>����us`.A�+�Ф@�������/(����}@�|�+���O�&X���C�oY��iX�����n��I��F����y�o
@ ����i�$���i�|������T���O������'�G3����H �3`?�3��~��G�������������_I�9
ŤH�1����Rd�.�#?��
c^$�2��+��K���Gݝ�8��O��?������c2y�g>*&�l�\���!J��hS��^FIy�b��4nz{���W�fyÏ:z�.��^��t3�{��9�}ѝL����P㟆�p�6�N}8�&��v<��=������,��<�~<���ڝ?8����/���!EO�}�X����I��(�����?�������E�O������&��	�?
���2��/���?���O	����H��_;q/�@�%B�������o���G����#�_�ET����O��o���$�9�0��t��%�����S�	�H���}����[�a���M��?"`���Z p��9���� �G�����ǋ/��Z=h�E�-e�T��t���m�穐���TVO���K�'����k�Y3���yi�$�����Շ���������I�l�⇊&�fi�85�Ge57�r�������p�6�Sf�W[��y�ɕV��wj�Y@�O���w�M����?���/�}>�}���Y���FH��Fg��+o�͂��\>^���6�cs������þO������4S����q��9w*M�.�-%kVM�P��]���<t9���7��ե(���m�ٶa��N�#S�N�oK`�����0`�����(�n�����a����%
5�����?Q0�	��	����	�������?�
`���I��E��ϭ�����{�{���Q +���&�?8��P�_^������k��=��}>��O7�|���U�/>�������!��s��;���z���v�殅�>��������dd���0�����%�L�7���/�F)g��b$9��$M\nj}~Ķ��6X��S]vx�2�������l��5��zTS���CH?UT;7V�w����9�k���/���Xn��v��#����>��e����p<3��V��*W�J:�Dnu��R�U��x^1Փz%#'idH���U��-������ �G���?�@���c���1�� ��ϭ�p��ٽp����$����Q@	ሣ��䩈��9��� &c6!�0dx�煐f��dB>��	Ș������?��h�;���S�kLe�.W�O��T�oO�a�����kӊ9�$AU}���E1r�{�3��x��<Io�Gu���u����v68��}�\�KFҭ�%i�O4�m���1^E���pI5�-;Ïj���Z����gq(x���p�[(p��!�+X�?�����s�9��E_�O����;㿝e��]C/��DHb�uF���xw����r�yӐs�t�{���&÷��������)_��V��3����$TՃǒ���$)c�W��sJ�y��F�R��/r>O�v��e������A��Z��Ӑ�-����O���� 꿠��8@��A��A��_��ЀE �'7��,	A�!�K��;��_���o'lVUe?�-B�Q�D?o���i!��'9z���,;)qV[���  �/�c 񭞽;�,U�joN�J��xq�l�G+��6�r�����i��g��ێ�v�RV��hV�S��:U�ҥ����Bc �QI଺h[��K�Y��۩de��4�H<����'�_���w���e��V��T���VI�r��<}����˵r��c���)Z R�l[��ӂHQ�-�i��6RSM:l{l*%��T�����/5������B��m��{��ݭ+e1��O�R5e2�4��$V�h���t�j�eK��Y��G���y�X�5��m̾�'Ţ���[olF2ލ8�?����X�(����C��@��/������C�
���4y����� 	����@������	$��( ��������_�������$?�9?�I!�#��ِ�%��y��b�y1f� �L����D)f���y?�������_N��$����^+��N��冋�ץ	nн��4+g�֦Ǟx�dW6?��:-��}t�;5WK�ꑻMMܗ��\0Jk=Y��A�����Z�=��]v�x����j���R��U%֫t�-�YT�����a���;� ��������%�G@��o���4�������?��!����<�q�?���O�7�?��C��/_~�/cT����� �?x���r��_뿭]kٳJǨ�T���0Y鳹}S��
���d���[��1����k�{j�/G��Ok��o�;�����'ՊG�X�]݉��bS���隽Us/X�ɰџr���~�[Wj����w4�r��G�d�'x�\-G0R3jwx�Տ�$oL�]�i�l����j^�%�+ʹ����w�b(��4gyc�Y/�84�VkK�ޜ�u�����*;�M�U[eӆ���l��0fE�$q}�<^z%A3��Y�ݼ'�ը���5��ª�Ue��}��MI�9Ġg��>99��$�#���X�e#���`�oA@��`�;����s�?������Z��?����;��<�H ��P���P�����>N�e�R X��ϭ�p�8�/����#dp���_����������=����M��C����w���=��b���3�#�O��m�� �� *��_��B� ��/��a�wQ(����` ����ԝ���H���9D� ��/���;�_��	��0�@T�����? �?���?��%������B�"`���3�@@�������� �#F�m! ������H ��� ��� ����
�`Q  ����������9j`���`��	�����������?�D�_:I���(@������po|��0�	��(�G���/P���P��G��������(�(������4[mc� ���[����̳{�?�N�OQg1���#2D�G��B6C�����8^�|2<�D�S��K%���,'��~����gx
����M����s�?}��Wk�S�Y�T�ܿ�l;!I#o6��jR�&��'���#j[��|��W�8<u��ލ;���rg�WS۵:kӝ�*�*�N=v��W� N�7s�v�;r�y̹�]�$긿tW�]�EǴ�e���Z�KƋX1�+S���|��/8f�a����P�����ԷP��C�W����)�����s���8�?���w��1�C)ku�Ji�XY�9��ڴ�:��߬P�Cv��������,sv��:��V�Ko�c#��w�=�I�ڭ}#�ԡbl��p��N�4�Uy�ޘZ����r��L��i��=�9�����f�;���?��	����C������/����/����+6��`������?迏�K��u���~�J}�cԾ����N�{QI��_��*�����"�4�S�*�f�u ��?f�t��u7,���L��S����Q,i��?1jiv�ƞ�6�>OvR��;Ic�O��)�6#&��㤙�k��vZ]�J��*'n�]?y�����ҩ��ۭ(�����������I��,Т}�VN�vlU�=ED�m�rZ$�(֠�8��b�Fz�,ʦn�FM8�F��񑦂� `&bdd~y�#���9��T�6g^C�(Fg1�Rj�+����<+E�L��um���݆��G�5'l���������6��Ϸ�����_�(���?)�p�����|�r����)X4�!���;�������_ݠ�[�X�_���H����i��=�e��Q �?�z��~@��?��������C�^��Y]U���W���/��r0v&%)�h�3��	\h������Γ��J??,]�Շ��v�UOg�s�s?�j~M�o����#����\O�|��y��7��)uٹ�./�ˋk	�mI�+w�$|̴�׬��(���Ω/��u]J���։6ט���ի�l���<���޳#��S�����,9C��)Y�����z�*3?����O���AWn=ъ�T�5����s��e͕d�_~�5����#�o�_�keS�����EU�9�n��bo��܏�N�����/�l�4��C�m��Ϛ��,sb�dM��B��GT���svp�Q\���^W�C[�/vNs1�rJ��(��+�s�;��2�DzzYc�Ǯ�}�ii����������n������?!�Ȁ�?F"�Ҿ4bB�?���4"Y����(XF���!�q Q~L�T�����������?$������䚗��$�$�{�v����뇀os�(�Ǟ?���ʕo�
��rQ+P��Z|��I��������!����A�Qs�� �����a��b������@�!�K���������Lܷ��Di+��������E����cA��s���%�F�-�7�R�G�'�wI����L�}�����~Oi?�uy?��dN�VNT�&����+mV۲��v���×�A���@@p����@&D@Q+�7\��7S�2++/P�^�D8�:k���:4O+��3�U��=rzh.k.�麘��e��z�i�4˻����G�ɆUsz���b9��L�a?�[����~ȝq?Uήñ��cS*�2�D��ݱ�u<���pkOYy�>�M����̌Ӻ7�4|d�]w�c#cƐ�Y7	Q,���~�Ǳ�4��������~��Q�������kM�B������$3�������������� ���Ri���Zű�Y%�t�O��Wc��Q*�V�*���]����8�l���
��!������_�������{�����%�h���8�Fȱ&̍M�|$a���.��#���e���eK�Z�o�-0���x��?5����?��a�/A�%j�V�a���@Ͽ����
���?����_�!c���@�tPa�����v�38����K�?|���}X��?WPY�������nh����������mN��?�>_�Q<��뺏u�c_M�D9���J�>?uV©S_�:�m�M�l��OVB�:s�|���u�
y^�r��_.�-�ŵ6�����Yx!�}�J�ZF�3{��R7�V��K�hߙ,�}��Z^O���7�gq]'n�2�E<p5���]_�^��Wkt�a��|�鴅�����������pY��o�lܼ���8��[֚��6���=R����`m�}��ڻ���m�Bn��'/)���ar�A_�ٶ�o�jϐCiLף���!sP�bʱ��m�qF��Z�Y�����,0��{�8�5_+�#�Om���G�o��(������?� ��_W!�/* �l�W�����C�����C!����O����L ����	����	����ު���!�B����E�����?����o�ߒ�0��	������������[���տ�K��!������$�6(�37�����������
������N�/��f���?���������?�����O!O�_�����;��w�����@A�|!rBV�����-���	������qQ�������L���������c�B�����?2B�*B�C!��������!���?���?��?迬��B���[���a�?7���"'"���H���3�?���?��C���w�`�'��Bǂ�����c�B�?y���2A1����B!������������(���h���	y꿵q
�m`@�� �l�W���7�?���
��:MกiUfI�z�$z��5� uS]��*eL��u��MS����4��Th��އo����Q��з�?��g�W�o O�������_j������ĝvҰM֒�%�yN�b5��-�>�}�W��v�s$;�Ju�&���:�pMbE�����NW�ڞ���I���D�ۍ�!���c��'k��K��(=Pn�����߳D!�q��^e��;����y���Qm��}�����T�^0������W�m`ַ(B��_~(�C�O~ȓ�/����y�����_~����ZmBڋ�1Eg��L��t#����̻<����ޚ��_S����Nw�v5=�����l�R8�G�'�M�*v{�Ө��i���ʉ��I��n�L=uI���B[|���⿯E1��
���<�]}҃�Q�F(D�������/����/�����h�Q�G�7������_��{�ݏ��۱�@�Ck���đn�X?����]�}��:'r	��5�����!�G�XLf��v0�SFu��贷��T�&ˮ���L�#���̌��b�9��~-�d[a����: v퍺�+j_�׫a��(����ܮ͒uvI�O�J���峖����d�%�\_�?�)�s����^g����RD ǉ��˛ۂRg�+5�kɇ��|r��D�X�=�;�.�p�/�b�`�����8�n}�ƭ#�<Ϋ��#�X=��0�侘�3lW�$ڝ���?�t��%L�6�*;����5���p
����[��/@�GA������?�&��¤������(�3w���,����x��}B� ��ϛ�	�F�S��r���,�xp ��������������E��n�G�?���O������LP$�����9�Ǆ�	�����������(����������?X2W@�������?���?,��
�ӷ���d�/�����c��U�Q�p=nz��`F/M���Ce[���b���#��k?��
��j�ϵ�!��#-�@���w���������:��|]�o��D�F�;�b���<���~�W}�F��项��x��b�6o��-����,�j��R$V��y把�Ⱦ2I�~�o�����"w�~UM8�Ǣ�ÎM��O���v����T��í=e����6��u��33N��L��=v�	���C�g]��Y����]�ci&gmkݍ������6�6�1ʋ�ך�+�Du����If���B���n�]��Z<�xD@����������H���F2E!��;�_��g���/����|��rB����"�y7�C������
��	��;G� �[��?���/���z�����Q�M�͆�#Ǔ��c�ڳ�5�/Z�}�?�%�:<�9��`���ӵL�j ��?>� T�N�N��*a7�r]�Q��*�b�w�mY�ww�1�����U�~����nW&6J��Q���꫚��&���  i�_�@�"�?��l<`ek�ܔ��}\f�h����d�c&!Q�Űv�:���y��ۑ�c��C�U�tԎC��h���3�߉5�����oF!�~g�����������	��[���+���
�(��5���
c������j,+�F��Ѥ�S�IX�fP�nb*��&�C�*C,i�}�V��E��{�B�6�����3tH�����9#	;�����&�a8[����yT+_��<�O��6VY�Ub���`o�7DZSrl�VEU;��R��U�(���9GI8/�t��X:	�O=lՏf���ע�?��\��t����Q����P����ܐ;��,���y7�C���_~���?�o��J�z�¡K��kR����7�"�C����N��]�?zȟ��x�#|߯����#7(��B��4&��L�A������V�+Fԕ4��|��6��?��&4gG�$ ��Z������R����#��_Wa�Q��/���P��_P��_0��/��Ѐ�����*��r��4��Q��lݧ�ޡg�D[M���nR������{�o�@���(��p�n:کj��;�_V�8�O����k[4&��ȧ�F+�jQe�Mg��v+]�\�gJm5u?T�^]�;�.�Y������CR�ǩl���<��^�f<������`(�����m��z�^����Dr��5n�ժ�EcM�
2��G�kn+Q8ciJ��9,F�˛�\�V%?��b�lt��TH��Ƈ}��z��8�#��ӄ��(��K:�L��g{+Z!��ic-Nsdnc��Z-��)}��ZԲ�>=�	��Z��������y��	�?���6�����,������_��L��'�O�t������2�R����(�{��y���:�n¨GD%��2����=v����޴�\���������t6F���t/RAJ>&t�һ�>�������Ӈ��;��IKw��y[�<cs=��l_�T�lL~���k�^��~�R������D����s���?��?�	:��������@5�C55��%��D��W2� �JFl����񢒺٤O��z��		����8��U+E�Q��A`$G.��УmpB�����~�WI_��������_9v�x?�������S�?*��%?^&���"�o�59�o?}x�d��B�<_6�ޙ����tr7��6����{��n��g�&mcn�R����XZFP�<�h[z~B��OW��o�K��N�+�{��Y�MBQ��v�w�	ýQ��T�#v0z?��Bw<��7j�~��w5#����m��_��n��ݽ��]H��u���垓k0��o��,�u����z|I���ݶt'��/���d?'״�Q#�Q�c�Wv�G���*[���KJZ��M<}r��{�0x���nG�����"�"�}��e���?)=৯j�Uz���o��+K�OO���C�3    (�A~z � 