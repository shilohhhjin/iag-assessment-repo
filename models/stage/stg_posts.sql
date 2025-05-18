{{
    config( materialized = 'view' )
}}

with source as (

    select 
        id as post_id,
        posttypeid as post_type_id,
        acceptedanswerid as accepted_answer_id,
        parentid as parent_id,
        creationdate as creation_date,
        score,
        viewcount as view_count,
        body,
        owneruserid as owner_user_id,
        lasteditoruserid as last_editor_user_id,
        lasteditordisplayname as last_editor_display_name,
        lasteditdate as last_edit_date,
        lastactivitydate as last_activity_date,
        title,
        tags,
        answercount as answer_count,
        commentcount as comment_count,
        favoritecount as favorite_count,
        communityowneddate as community_owned_date,
        contentlicense as content_license
    from 
       {{ ref('raw_posts') }}
)

select * from source 