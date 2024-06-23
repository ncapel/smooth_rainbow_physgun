function GrantAccess()

	if not SERVER then
		return
	end

	allow_user_group('vip')
	allow_user_group('epicvip')
	allow_user_group('moderator')
	allow_user_group('admin')
	allow_user_group('superadmin')
	allow_user_group('owner')
	allow_user('STEAM_0:0:97425009')
end

hook.Add( "Initialize", "load groups and users", GrantAccess);